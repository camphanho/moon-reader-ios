import { Model } from '@nozbe/watermelondb';
import { field, text, date } from '@nozbe/watermelondb/decorators';

// TypeScript interface
export interface Note {
  id: string;
  bookId: string;
  chapter: number;
  position: number;
  text: string;
  createdAt: Date;
  modifiedAt: Date;
}

// WatermelonDB Model class
export class NoteModel extends Model {
  static table = 'notes';

  @text('bookId') bookId!: string;
  @field('chapter') chapter!: number;
  @field('position') position!: number;
  @text('text') text!: string;
  @date('createdAt') createdAt!: Date;
  @date('modifiedAt') modifiedAt!: Date;
}

