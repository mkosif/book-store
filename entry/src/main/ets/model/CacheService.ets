import BookModel from './BookModel';

const CACHE_KEY = 'cachedBooks';

export class CacheService {
  private static instance: CacheService;

  private constructor() {}

  static getInstance(): CacheService {
    if (!CacheService.instance) {
      CacheService.instance = new CacheService();
    }
    return CacheService.instance;
  }

  saveBooks(books: BookModel[]) {
    try {
      AppStorage.setOrCreate(CACHE_KEY, JSON.stringify(books));
    } catch (e) {
      console.error('CacheService: failed to save books:', e);
    }
  }

  getCachedBooks(): BookModel[] {
    try {
      const stored = AppStorage.get<string>(CACHE_KEY);
      if (stored) {
        return JSON.parse(stored) as BookModel[];
      }
    } catch (e) {
      console.error('CacheService: failed to load books:', e);
    }
    return [];
  }

  hasCachedBooks(): boolean {
    return this.getCachedBooks().length > 0;
  }
}
