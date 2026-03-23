export class NotesService {
  private static instance: NotesService;
  private notesMap: Map<string, string> = new Map();

  private constructor() {
    this.loadFromStorage();
  }

  public static getInstance(): NotesService {
    if (!NotesService.instance) {
      NotesService.instance = new NotesService();
    }
    return NotesService.instance;
  }

  private loadFromStorage() {
    const saved = AppStorage.get<string>('BookNotesMap');
    if (saved) {
      try {
        const pairs: string[][] = JSON.parse(saved) as string[][];
        for (const pair of pairs) {
          if (pair.length === 2) {
            this.notesMap.set(pair[0], pair[1]);
          }
        }
      } catch (e) {
        console.error('Failed to parse BookNotesMap');
      }
    }
  }

  private saveToStorage() {
    const pairs: string[][] = [];
    this.notesMap.forEach((value: string, key: string) => {
      pairs.push([key, value]);
    });
    AppStorage.setOrCreate('BookNotesMap', JSON.stringify(pairs));
  }

  getNote(bookTitle: string): string {
    return this.notesMap.get(bookTitle) ?? '';
  }

  setNote(bookTitle: string, note: string) {
    if (note.trim() === '') {
      this.notesMap.delete(bookTitle);
    } else {
      this.notesMap.set(bookTitle, note);
    }
    this.saveToStorage();
  }
}
