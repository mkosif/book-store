export enum ThemeMode {
  LIGHT,
  DARK
}

export class ThemeService {
  private static instance: ThemeService;
  private mode: ThemeMode = ThemeMode.LIGHT;

  private constructor() {
    let saved = AppStorage.get<number>('ThemeMode');
    if (saved !== undefined) {
      this.mode = saved as ThemeMode;
    }
  }

  public static getInstance(): ThemeService {
    if (!ThemeService.instance) {
      ThemeService.instance = new ThemeService();
    }
    return ThemeService.instance;
  }

  getMode(): ThemeMode {
    return this.mode;
  }

  setMode(mode: ThemeMode) {
    this.mode = mode;
    AppStorage.setOrCreate('ThemeMode', mode);
  }

  getBackgroundColor(): ResourceColor {
    return this.mode === ThemeMode.LIGHT ? Color.White : Color.Black;
  }

  getTextColor(): ResourceColor {
    return this.mode === ThemeMode.LIGHT ? Color.Black : Color.White;
  }

  getCardBackgroundColor(): ResourceColor {
    return this.mode === ThemeMode.LIGHT ? '#f0f0f0' : '#333333';
  }
}
