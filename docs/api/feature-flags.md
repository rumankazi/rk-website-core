# Feature Flags System

The feature flag system enables gradual feature rollouts, A/B testing, and emergency feature toggles without requiring new deployments.

## Architecture Overview

```typescript
// Feature flag configuration
interface FeatureFlag {
  key: string;
  enabled: boolean;
  rolloutPercentage: number;
  rules: FeatureFlagRules;
  createdAt: Date;
  updatedAt: Date;
}

interface FeatureFlagRules {
  userIds?: string[]; // Specific user IDs
  userRoles?: string[]; // User roles (admin, beta, etc.)
  environments?: string[]; // Environment restrictions
  regions?: string[]; // Geographic restrictions
  timeWindows?: TimeWindow[]; // Time-based activation
}

interface TimeWindow {
  start: Date;
  end: Date;
  timezone: string;
}
```

## Implementation Strategy

### Phase 1: Basic Feature Flags (Current Implementation)

**Simple Boolean Flags**:

```typescript
// src/lib/feature-flags.ts
const FEATURE_FLAGS = {
  NEW_DASHBOARD: process.env.FEATURE_NEW_DASHBOARD === "true",
  BETA_API: process.env.FEATURE_BETA_API === "true",
  ADVANCED_ANALYTICS: process.env.FEATURE_ADVANCED_ANALYTICS === "true",
} as const;

export function isFeatureEnabled(flag: keyof typeof FEATURE_FLAGS): boolean {
  return FEATURE_FLAGS[flag] ?? false;
}
```

**Usage in Components**:

```typescript
// src/components/dashboard/DashboardPage.tsx
import { isFeatureEnabled } from "@/lib/feature-flags";

export function DashboardPage() {
  const showNewDashboard = isFeatureEnabled("NEW_DASHBOARD");

  return <div>{showNewDashboard ? <NewDashboard /> : <LegacyDashboard />}</div>;
}
```

### Phase 2: User-Based Feature Flags

**Enhanced Flag System**:

```typescript
// src/lib/feature-flags/types.ts
export interface FeatureFlagContext {
  user?: {
    id: string;
    role: string;
    email: string;
  };
  environment: string;
  region?: string;
}

export interface FeatureFlagConfig {
  enabled: boolean;
  rolloutPercentage: number;
  rules: {
    userIds?: string[];
    userRoles?: string[];
    betaUsers?: boolean;
    adminOnly?: boolean;
  };
}
```

**Flag Evaluation Logic**:

```typescript
// src/lib/feature-flags/evaluator.ts
import { FeatureFlagContext, FeatureFlagConfig } from "./types";

export async function evaluateFeatureFlag(
  flagKey: string,
  context: FeatureFlagContext,
  config: FeatureFlagConfig
): Promise<boolean> {
  // If flag is globally disabled, return false
  if (!config.enabled) return false;

  // Check user-specific rules first
  if (config.rules.userIds?.includes(context.user?.id || "")) {
    return true;
  }

  // Check role-based rules
  if (config.rules.userRoles?.includes(context.user?.role || "")) {
    return true;
  }

  // Admin-only flag
  if (config.rules.adminOnly && context.user?.role === "admin") {
    return true;
  }

  // Beta users flag
  if (config.rules.betaUsers && context.user?.role === "beta") {
    return true;
  }

  // Percentage-based rollout
  if (config.rolloutPercentage > 0 && context.user) {
    const userHash = hashUserId(context.user.id);
    const userPercentile = userHash % 100;
    return userPercentile < config.rolloutPercentage;
  }

  return false;
}

function hashUserId(userId: string): number {
  // Simple hash function for consistent user assignment
  let hash = 0;
  for (let i = 0; i < userId.length; i++) {
    const char = userId.charCodeAt(i);
    hash = (hash << 5) - hash + char;
    hash = hash & hash; // Convert to 32-bit integer
  }
  return Math.abs(hash);
}
```

### Phase 3: Database-Backed Feature Flags

**Database Schema**:

```prisma
// prisma/schema.prisma
model FeatureFlag {
  id                String   @id @default(cuid())
  key               String   @unique
  name              String
  description       String?
  enabled           Boolean  @default(false)
  rolloutPercentage Int      @default(0)
  rules             Json     @default("{}")
  createdAt         DateTime @default(now())
  updatedAt         DateTime @updatedAt
  createdBy         String

  // Audit trail
  flagEvents FeatureFlagEvent[]

  @@map("feature_flags")
}

model FeatureFlagEvent {
  id          String      @id @default(cuid())
  flagId      String
  flag        FeatureFlag @relation(fields: [flagId], references: [id], onDelete: Cascade)
  eventType   String      // 'enabled', 'disabled', 'rollout_changed', 'rule_updated'
  oldValue    Json?
  newValue    Json?
  changedBy   String
  timestamp   DateTime    @default(now())

  @@map("feature_flag_events")
}
```

**Flag Service**:

```typescript
// src/lib/feature-flags/service.ts
import { db } from "@/lib/db";
import { FeatureFlagContext } from "./types";
import { evaluateFeatureFlag } from "./evaluator";

export class FeatureFlagService {
  private cache = new Map<string, any>();
  private cacheExpiry = new Map<string, number>();
  private readonly CACHE_TTL = 60000; // 1 minute

  async getFlag(key: string): Promise<any> {
    const cached = this.cache.get(key);
    const expiry = this.cacheExpiry.get(key);

    if (cached && expiry && Date.now() < expiry) {
      return cached;
    }

    const flag = await db.featureFlag.findUnique({
      where: { key },
    });

    if (flag) {
      this.cache.set(key, flag);
      this.cacheExpiry.set(key, Date.now() + this.CACHE_TTL);
    }

    return flag;
  }

  async isEnabled(key: string, context: FeatureFlagContext): Promise<boolean> {
    const flag = await this.getFlag(key);

    if (!flag) {
      console.warn(`Feature flag "${key}" not found`);
      return false;
    }

    return evaluateFeatureFlag(key, context, {
      enabled: flag.enabled,
      rolloutPercentage: flag.rolloutPercentage,
      rules: flag.rules,
    });
  }

  async updateFlag(
    key: string,
    updates: Partial<any>,
    changedBy: string
  ): Promise<void> {
    const current = await this.getFlag(key);

    await db.featureFlag.update({
      where: { key },
      data: updates,
    });

    // Log the change
    await db.featureFlagEvent.create({
      data: {
        flagId: current.id,
        eventType: "rule_updated",
        oldValue: current,
        newValue: { ...current, ...updates },
        changedBy,
      },
    });

    // Clear cache
    this.cache.delete(key);
    this.cacheExpiry.delete(key);
  }
}

export const featureFlagService = new FeatureFlagService();
```

### Phase 4: Redis-Backed Real-Time Flags

**Real-Time Updates**:

```typescript
// src/lib/feature-flags/redis-service.ts
import Redis from "ioredis";
import { FeatureFlagService } from "./service";

export class RedisFeatureFlagService extends FeatureFlagService {
  private redis: Redis;

  constructor() {
    super();
    this.redis = new Redis(process.env.REDIS_URL!);
    this.setupSubscription();
  }

  private setupSubscription() {
    const subscriber = new Redis(process.env.REDIS_URL!);
    subscriber.subscribe("feature-flags:updates");

    subscriber.on("message", (channel, message) => {
      if (channel === "feature-flags:updates") {
        const { key } = JSON.parse(message);
        // Clear cache for updated flag
        this.cache.delete(key);
        this.cacheExpiry.delete(key);
      }
    });
  }

  async updateFlag(
    key: string,
    updates: any,
    changedBy: string
  ): Promise<void> {
    await super.updateFlag(key, updates, changedBy);

    // Notify all instances
    await this.redis.publish("feature-flags:updates", JSON.stringify({ key }));
  }
}
```

## Usage Patterns

### React Hook for Feature Flags

```typescript
// src/hooks/useFeatureFlag.ts
import { useSession } from "next-auth/react";
import { useEffect, useState } from "react";
import { featureFlagService } from "@/lib/feature-flags/service";

export function useFeatureFlag(flagKey: string): boolean {
  const { data: session } = useSession();
  const [enabled, setEnabled] = useState(false);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    async function checkFlag() {
      if (!session?.user) {
        setEnabled(false);
        setLoading(false);
        return;
      }

      try {
        const result = await featureFlagService.isEnabled(flagKey, {
          user: {
            id: session.user.id,
            role: session.user.role,
            email: session.user.email,
          },
          environment: process.env.NODE_ENV,
        });

        setEnabled(result);
      } catch (error) {
        console.error(`Error checking feature flag ${flagKey}:`, error);
        setEnabled(false);
      } finally {
        setLoading(false);
      }
    }

    checkFlag();
  }, [flagKey, session]);

  return enabled;
}
```

### API Route Protection

```typescript
// src/middleware.ts
import { NextRequest, NextResponse } from "next/server";
import { getToken } from "next-auth/jwt";
import { featureFlagService } from "@/lib/feature-flags/service";

export async function middleware(request: NextRequest) {
  // Check if accessing beta API
  if (request.nextUrl.pathname.startsWith("/api/beta/")) {
    const token = await getToken({ req: request });

    if (!token) {
      return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
    }

    const hasAccess = await featureFlagService.isEnabled("BETA_API", {
      user: {
        id: token.sub!,
        role: token.role as string,
        email: token.email!,
      },
      environment: process.env.NODE_ENV!,
    });

    if (!hasAccess) {
      return NextResponse.json(
        { error: "Feature not available" },
        { status: 403 }
      );
    }
  }

  return NextResponse.next();
}
```

### Component-Level Feature Gates

```typescript
// src/components/FeatureGate.tsx
import { useFeatureFlag } from "@/hooks/useFeatureFlag";

interface FeatureGateProps {
  flag: string;
  children: React.ReactNode;
  fallback?: React.ReactNode;
}

export function FeatureGate({
  flag,
  children,
  fallback = null,
}: FeatureGateProps) {
  const isEnabled = useFeatureFlag(flag);

  return isEnabled ? <>{children}</> : <>{fallback}</>;
}

// Usage
<FeatureGate flag="NEW_DASHBOARD" fallback={<LegacyDashboard />}>
  <NewDashboard />
</FeatureGate>;
```

## Admin Dashboard

### Feature Flag Management UI

```typescript
// src/app/admin/feature-flags/page.tsx
import { featureFlagService } from "@/lib/feature-flags/service";

export default async function FeatureFlagsPage() {
  const flags = await db.featureFlag.findMany({
    orderBy: { updatedAt: "desc" },
  });

  return (
    <div className="space-y-6">
      <h1>Feature Flags Management</h1>

      {flags.map((flag) => (
        <FeatureFlagCard key={flag.id} flag={flag} />
      ))}
    </div>
  );
}

function FeatureFlagCard({ flag }: { flag: any }) {
  return (
    <div className="border rounded-lg p-4">
      <div className="flex justify-between items-start">
        <div>
          <h3 className="font-semibold">{flag.name}</h3>
          <p className="text-gray-600">{flag.description}</p>
          <code className="text-sm bg-gray-100 px-2 py-1 rounded">
            {flag.key}
          </code>
        </div>

        <div className="text-right">
          <div
            className={`px-2 py-1 rounded text-sm ${
              flag.enabled
                ? "bg-green-100 text-green-800"
                : "bg-gray-100 text-gray-800"
            }`}
          >
            {flag.enabled ? "Enabled" : "Disabled"}
          </div>

          {flag.enabled && (
            <div className="text-sm text-gray-600 mt-1">
              {flag.rolloutPercentage}% rollout
            </div>
          )}
        </div>
      </div>
    </div>
  );
}
```

## Best Practices

### Flag Naming Convention

```typescript
// Use descriptive, hierarchical names
const FLAGS = {
  // Feature areas
  "dashboard.redesign": "NEW_DASHBOARD",
  "api.v2": "API_V2",
  "auth.social-login": "SOCIAL_LOGIN",

  // Experiments
  "experiment.checkout-flow": "CHECKOUT_EXPERIMENT",
  "experiment.pricing-display": "PRICING_EXPERIMENT",

  // Kill switches
  "killswitch.external-api": "DISABLE_EXTERNAL_API",
  "killswitch.notifications": "DISABLE_NOTIFICATIONS",
};
```

### Flag Lifecycle Management

1. **Creation**: New flag starts disabled (0% rollout)
2. **Testing**: Enable for internal users and beta testers
3. **Gradual Rollout**: 5% → 25% → 50% → 100%
4. **Monitoring**: Track metrics at each rollout stage
5. **Cleanup**: Remove flag after full rollout (technical debt)

### Monitoring & Alerting

```typescript
// Track feature flag usage
export function trackFeatureFlagUsage(
  flag: string,
  enabled: boolean,
  userId?: string
) {
  // Send to analytics/monitoring
  analytics.track("feature_flag_evaluated", {
    flag,
    enabled,
    userId,
    timestamp: new Date().toISOString(),
  });
}
```

## Security Considerations

### Access Control

```typescript
// Only admins can modify feature flags
export async function updateFeatureFlag(
  flagKey: string,
  updates: any,
  user: { id: string; role: string }
) {
  if (user.role !== "admin") {
    throw new Error("Unauthorized: Admin access required");
  }

  return featureFlagService.updateFlag(flagKey, updates, user.id);
}
```

### Audit Logging

All feature flag changes are logged with:

- Who made the change
- What was changed (old vs new values)
- When the change occurred
- Why the change was made (optional comment)

---

::: tip Implementation Strategy
Start with simple environment variable flags, then gradually enhance with user-based rules, database persistence, and real-time updates as your application grows.
:::
