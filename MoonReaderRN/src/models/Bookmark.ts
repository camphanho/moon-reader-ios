import { Model } from '@nozbe/watermelondb';
import { field, text, date } from '@nozbe/watermelondb/decorators';

// TypeScript interface
export interface Bookmark {
  id: string;
  bookId: string;
  bookFilename: string;
  chapter: number;
  position: number;
  splitIndex: number;
  highlightLength: number;
  highlightColor: HighlightColor;
  time: Date;
  note?: string;
  originalText: string;
  isUnderline: boolean;
  isStrikethrough: boolean;
}

export enum HighlightColor {
  YELLOW = 0,
  GREEN = 1,
  BLUE = 2,
  PINK = 3,
  PURPLE = 4,
  ORANGE = 5,
}

// WatermelonDB Model class
export class BookmarkModel extends Model {
  static table = 'bookmarks';

  @text('bookId') bookId!: string;
  @text('bookFilename') bookFilename!: string;
  @text('lowerFilename') lowerFilename!: string;
  @field('chapter') chapter!: number;
  @field('position') position!: number;
  @field('splitIndex') splitIndex!: number;
  @field('highlightLength') highlightLength!: number;
  @field('highlightColor') highlightColor!: number;
  @date('time') time!: Date;
  @text('note') note?: string;
  @text('originalText') originalText!: string;
  @field('isUnderline') isUnderline!: boolean;
  @field('isStrikethrough') isStrikethrough!: boolean;
}

