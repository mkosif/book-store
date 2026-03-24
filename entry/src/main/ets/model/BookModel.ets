export default interface BookModel {
  id: string;
  title: string;
  pageCount: number;
  image: string;
  description: string;
  categories: string[];
  authors: string[];
  publishedDate: string;
  publisher: string;
  previewLink: string;
  language: string;
}