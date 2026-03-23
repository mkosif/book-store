export class GoalService {
  private static instance: GoalService;

  private constructor() {}

  public static getInstance(): GoalService {
    if (!GoalService.instance) {
      GoalService.instance = new GoalService();
    }
    return GoalService.instance;
  }

  getGoal(): number {
    return AppStorage.get<number>('ReadingGoal') ?? 5;
  }

  setGoal(goal: number) {
    AppStorage.setOrCreate('ReadingGoal', goal);
  }
}
