import { getHttp } from '../utils/RCP';
import BookModel from './BookModel';
import { RSPModel } from './RSPModel';
import { volModel } from './volModel';
import { getUrl, getBaseUrl, getApiKey } from '../utils/Constants';
import { CacheService } from './CacheService';

const FIELDS = 'items(id,volumeInfo/title,volumeInfo/pageCount,volumeInfo/imageLinks/smallThumbnail,volumeInfo/description,volumeInfo/categories,volumeInfo/authors,volumeInfo/publishedDate,volumeInfo/publisher,volumeInfo/previewLink,volumeInfo/language)';

class BookService {
  private static mapBooks(rsp: RSPModel): BookModel[] {
    return (rsp.items || []).map<BookModel>((i: volModel) => ({
      id: i.id || '',
      title: i.volumeInfo.title || '',
      pageCount: i.volumeInfo.pageCount || 0,
      image: i.volumeInfo.imageLinks?.smallThumbnail || '',
      description: i.volumeInfo.description || '',
      categories: i.volumeInfo.categories || [],
      authors: i.volumeInfo.authors || [],
      publishedDate: i.volumeInfo.publishedDate || '',
      publisher: i.volumeInfo.publisher || '',
      previewLink: i.volumeInfo.previewLink || '',
      language: i.volumeInfo.language || ''
    }));
  }

  static async getBooks(uiContext: UIContext): Promise<BookModel[]> {
    const requestUrl = getUrl(uiContext);
    try {
      const response = await getHttp(uiContext, requestUrl) ?? [];
      const rsp = response as RSPModel;
      const books = BookService.mapBooks(rsp);
      if (books.length > 0) {
        CacheService.getInstance().saveBooks(books);
      }
      return books;
    } catch (e) {
      console.error('BookService: network error, using cache:', e);
      return CacheService.getInstance().getCachedBooks();
    }
  }

  static async searchBooks(uiContext: UIContext, query: string): Promise<BookModel[]> {
    const baseUrl = getBaseUrl(uiContext);
    const url = `${baseUrl}volumes?q=${encodeURIComponent(query)}&fields=${FIELDS}&key=${getApiKey(uiContext)}`;
    try {
      const response = await getHttp(uiContext, url) ?? [];
      const rsp = response as RSPModel;
      return BookService.mapBooks(rsp);
    } catch (e) {
      console.error('BookService: search failed:', e);
      return [];
    }
  }
}

export default BookService;
