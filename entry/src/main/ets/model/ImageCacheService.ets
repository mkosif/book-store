export class ImageCacheService {
  private static instance: ImageCacheService;
  private cache: Record<string, string> = {};

  private constructor() {
    this.loadFromStorage();
  }

  public static getInstance(): ImageCacheService {
    if (!ImageCacheService.instance) {
      ImageCacheService.instance = new ImageCacheService();
    }
    return ImageCacheService.instance;
  }

  private loadFromStorage() {
    const saved = AppStorage.get<string>('ImageCacheMap');
    if (saved) {
      try {
        this.cache = JSON.parse(saved) as Record<string, string>;
      } catch (e) {
        console.error('Failed to parse ImageCacheMap');
      }
    }
  }


  getImage(url: string): string {
    return this.cache[url] ?? url;
  }

}
