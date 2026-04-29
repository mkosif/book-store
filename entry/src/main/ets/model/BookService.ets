import { getHttp } from '../utils/RCP';
import BookModel from './BookModel';
import { RSPModel } from './RSPModel';
import { volModel } from './volModel';
import { getUrl, getBaseUrl, getApiKey } from '../utils/Constants';
import { CacheService } from './CacheService';

const FIELDS = [
  'items(',
  'id',
  ',volumeInfo/title',
  ',volumeInfo/pageCount',
  ',volumeInfo/imageLinks/smallThumbnail',
  ',volumeInfo/description',
  ',volumeInfo/categories',
  ',volumeInfo/authors',
  ',volumeInfo/publishedDate',
  ',volumeInfo/publisher',
  ',volumeInfo/previewLink',
  ',volumeInfo/language',
  ')'
].join('');

class BookService {
  private static errorMessage(error: Error): string {
    if (error.message.includes('HTTP 429')) {
      return 'Google Books API limit reached. Check the API key or wait before retrying.'
    }
    if (error.message.includes('HTTP 403')) {
      return 'Google Books API rejected the request. Check API key permissions.'
    }
    if (error.message.includes('HTTP 400')) {
      return 'Google Books API request is invalid. Check the API key and query.'
    }
    return `Google Books API error: ${error.message}`
  }

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
      if (!rsp.items || rsp.items.length === 0) {
        throw new Error('Google Books API returned no books.')
      }
      const books = BookService.mapBooks(rsp);
      if (books.length > 0) {
        CacheService.getInstance().saveBooks(books);
      }
      return books;
    } catch (e) {
      const cachedBooks = CacheService.getInstance().getCachedBooks();
      if (cachedBooks.length > 0) {
        return cachedBooks;
      }
      const error = e as Error;
      console.error('BookService: network error:', error.message);
      throw new Error(BookService.errorMessage(error));
    }
  }

  static async searchBooks(uiContext: UIContext, query: string): Promise<BookModel[]> {
    const baseUrl = getBaseUrl(uiContext);
    const url = `${baseUrl}volumes?q=${encodeURIComponent(query)}&fields=${FIELDS}&key=${getApiKey(uiContext)}`;
    try {
      const response = await getHttp(uiContext, url) ?? [];
      const rsp = response as RSPModel;
      if (!rsp.items || rsp.items.length === 0) {
        throw new Error('Google Books API returned no search results.')
      }
      return BookService.mapBooks(rsp);
    } catch (e) {
      const error = e as Error;
      console.error('BookService: search failed:', error.message);
      throw new Error(BookService.errorMessage(error));
    }
  }
}

export default BookService;
