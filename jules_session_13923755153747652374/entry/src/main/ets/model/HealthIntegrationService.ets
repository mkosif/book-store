export class HealthIntegrationService {
  private static instance: HealthIntegrationService;

  private constructor() {}

  public static getInstance(): HealthIntegrationService {
    if (!HealthIntegrationService.instance) {
      HealthIntegrationService.instance = new HealthIntegrationService();
    }
    return HealthIntegrationService.instance;
  }

  syncWithHealth(readingTimeMinutes: number) {
    console.info(`Syncing ${readingTimeMinutes} minutes of reading with Huawei Health...`);
    // In real app, use health services API
  }
}
