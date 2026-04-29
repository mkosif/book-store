import BookModel from './BookModel';

export class ShareService {
  private static instance: ShareService;

  private constructor() {}

  public static getInstance(): ShareService {
    if (!ShareService.instance) {
      ShareService.instance = new ShareService();
    }
    return ShareService.instance;
  }

  shareBook(book: BookModel) {
    const shareMessage = `Check out this book: ${book.title} by ${book.authors ? book.authors.join(', ') : 'Unknown'}. ${book.previewLink}`;
    console.info('Sharing book: ' + shareMessage);
    // In real HarmonyOS, use system share sheet (wantAgent or similar)
  }
}
