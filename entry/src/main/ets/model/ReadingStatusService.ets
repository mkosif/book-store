const READING_STATUS_KEY = 'readingStatus';

export enum ReadingStatus {
  NONE = 'None',
  TO_READ = 'To Read',
  READING = 'Reading',
  READ = 'Read'
}

export class ReadingStatusService {
  private static instance: ReadingStatusService;
  private statusMap: Map<string, ReadingStatus> = new Map();

  private constructor() {
    this.load();
  }

  static getInstance(): ReadingStatusService {
    if (!ReadingStatusService.instance) {
      ReadingStatusService.instance = new ReadingStatusService();
    }
    return ReadingStatusService.instance;
  }

  private load() {
    const stored = AppStorage.get<string>(READING_STATUS_KEY);
    if (stored) {
      try {
        const pairs: string[][] = JSON.parse(stored) as string[][];
        for (const pair of pairs) {
          if (pair.length === 2) {
            this.statusMap.set(pair[0], pair[1] as ReadingStatus);
          }
        }
      } catch (e) {
        console.error('ReadingStatusService: failed to load:', e);
      }
    }
  }

  private save() {
    const pairs: string[][] = [];
    this.statusMap.forEach((value: ReadingStatus, key: string) => {
      pairs.push([key, value]);
    });
    AppStorage.setOrCreate(READING_STATUS_KEY, JSON.stringify(pairs));
  }

  getStatus(id: string): ReadingStatus {
    return this.statusMap.get(id) ?? ReadingStatus.TO_READ;
  }

  setStatus(id: string, status: ReadingStatus) {
    this.statusMap.set(id, status);
    this.save();
  }

  getAllStatuses(): Map<string, ReadingStatus> {
    return this.statusMap;
  }
}
