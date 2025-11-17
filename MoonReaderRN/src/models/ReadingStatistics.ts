import { Model } from '@nozbe/watermelondb';
import { field, text } from '@nozbe/watermelondb/decorators';

// TypeScript interface
export interface ReadingStatistics {
  id: string;
  bookFilename: string;
  usedTime: number; // seconds
  readWords: number;
  dates: Date[];
}

// WatermelonDB Model class
export class ReadingStatisticsModel extends Model {
  static table = 'statistics';

  @text('bookFilename') bookFilename!: string;
  @field('usedTime') usedTime!: number;
  @field('readWords') readWords!: number;
  @text('dates') dates!: string; // JSON array as string

  // Helper methods
  get readHours(): number {
    return this.usedTime / 3600.0;
  }

  get averageWordsPerMinute(): number {
    if (this.usedTime === 0) return 0;
    return Math.round(this.readWords / (this.usedTime / 60.0));
  }

  get datesArray(): Date[] {
    try {
      const timestamps = JSON.parse(this.dates || '[]') as number[];
      return timestamps.map((t) => new Date(t));
    } catch {
      return [];
    }
  }
}

