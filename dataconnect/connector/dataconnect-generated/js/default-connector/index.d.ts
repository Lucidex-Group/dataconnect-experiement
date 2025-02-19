import { ConnectorConfig, DataConnect, QueryRef, QueryPromise } from 'firebase/data-connect';

export const connectorConfig: ConnectorConfig;

export type TimestampString = string;
export type UUIDString = string;
export type Int64String = string;
export type DateString = string;


export interface ListMoviesData {
  movies: ({
    id: UUIDString;
    title: string;
    imageUrl: string;
    genre?: string | null;
    movieMetadata_on_movie?: {
      rating?: number | null;
    };
  } & Movie_Key)[];
}

export interface MovieMetadata_Key {
  id: UUIDString;
  __typename?: 'MovieMetadata_Key';
}

export interface Movie_Key {
  id: UUIDString;
  __typename?: 'Movie_Key';
}


/* Allow users to create refs without passing in DataConnect */
export function listMoviesRef(): (QueryRef<ListMoviesData, undefined> & { __angular?: false });
/* Allow users to pass in custom DataConnect instances */
export function listMoviesRef(dc: DataConnect): (QueryRef<ListMoviesData, undefined> & { __angular?: false });

export function listMovies(): QueryPromise<ListMoviesData, undefined>;
export function listMovies(dc: DataConnect): QueryPromise<ListMoviesData, undefined>;

