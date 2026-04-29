import { ImagesModel } from './ImagesModel';

export interface VolumeInfoModel {
  title: string
  pageCount: number
  imageLinks: ImagesModel
  description: string
  categories: string[]
  authors: string[]
  publishedDate: string
  publisher: string
  previewLink: string
  language: string
}