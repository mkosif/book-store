import BookModel from '../model/BookModel';
import BookService from '../model/BookService';

@Observed
export class HomeViewModel {
  offsetX: number = 0
  offsetY: number = 0
  name: ResourceStr = $r('app.string.games')
  private responses: ResourceStr[] = [
    $r('app.string.noway'),
    $r('app.string.choosebooks'),
    $r('app.string.catchme'),
    $r('app.string.nicetry'),
    $r('app.string.oopss')
  ]
  allBooks: BookModel[] = []
  currentBook: BookModel | null = null;
  private static _instance: HomeViewModel;

  private constructor() {
  }

  public static get instance(): HomeViewModel {
    if (!HomeViewModel._instance) {
      HomeViewModel._instance = new HomeViewModel();
    }
    return HomeViewModel._instance;
  }

  escape() {
    this.offsetX = this.randomOffset(-60, 60)
    this.offsetY = this.randomOffset(-70, 70)
  }

  getBookOfDay(): BookModel | null {
    if (this.allBooks.length === 0) return null;
    const today = new Date();
    const dateHash = today.getFullYear() * 10000 + (today.getMonth() + 1) * 100 + today.getDate();
    const index = dateHash % this.allBooks.length;
    return this.allBooks[index];
  }

  randomOffset(min: number, max: number): number {
    return (Date.now() % (max - min + 1)) + min;
  }

  getRandomResponse(): ResourceStr {
    let index = Date.now() % this.responses.length;
    return this.responses[index]
  }

  async fetchBooks(uiContext?: UIContext) {
    if (!uiContext) {
      console.error('UIContext is undefined. Cannot fetch books.');
      return;
    }

    try {
      this.allBooks = await BookService.getBooks(uiContext);
      console.info('HomeViewModel Books:', JSON.stringify(this.allBooks, null, 3));
    } catch (err) {
      console.error('Failed to fetch books:', JSON.stringify(err));
    }
  }
}
