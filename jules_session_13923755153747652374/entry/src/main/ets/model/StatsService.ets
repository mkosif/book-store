import { ReadingStatus } from './ReadingStatusService';

export class StatsService {
  private static instance: StatsService;

  private constructor() {}

  public static getInstance(): StatsService {
    if (!StatsService.instance) {
      StatsService.instance = new StatsService();
    }
    return StatsService.instance;
  }

  getReadingStats() {
    let statusMapSaved = AppStorage.get<string>('ReadingStatusMap');
    let stats = {
      toRead: 0,
      reading: 0,
      read: 0,
      total: 0
    };

    if (statusMapSaved) {
      try {
        let obj = JSON.parse(statusMapSaved);
        Object.values(obj).forEach(status => {
          stats.total++;
          if (status === ReadingStatus.TO_READ) stats.toRead++;
          else if (status === ReadingStatus.READING) stats.reading++;
          else if (status === ReadingStatus.READ) stats.read++;
        });
      } catch (e) {
        console.error('Failed to parse stats');
      }
    }
    return stats;
  }
}
