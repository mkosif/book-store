export class ImageCacheService {
  private static instance: ImageCacheService;
  private cache: Map<string, string> = new Map();

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
    let saved = AppStorage.get<string>('ImageCacheMap');
    if (saved) {
      try {
        let obj = JSON.parse(saved);
        this.cache = new Map(Object.entries(obj));
      } catch (e) {
        console.error('Failed to parse ImageCacheMap');
      }
    }
  }

  private saveToStorage() {
    let obj = Object.fromEntries(this.cache);
    AppStorage.setOrCreate('ImageCacheMap', JSON.stringify(obj));
  }

  getImage(url: string): string {
    return this.cache.get(url) ?? url;
  }

  cacheImage(url: string, localPath: string) {
    this.cache.set(url, localPath);
    this.saveToStorage();
  }
}
