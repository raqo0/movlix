import 'package:flutter/material.dart';
import 'package:movlix/models/movie.dart';
import 'package:movlix/models/my_app_user.dart';
import 'package:movlix/models/user_movies.dart';
import 'package:movlix/services/movie_service.dart';
import 'package:movlix/utils/constants.dart';
import 'package:movlix/widgets/custom_dialogs.dart';
import 'package:movlix/widgets/movie_card.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final MyAppUser? user = Provider.of<MyAppUser?>(context);
    //TODO: yo
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          HomeHeader(
            title: 'Trending movies',
            seeAllPressed: () {
              print('Go to Trending :)');
            },
          ),
          FutureBuilder<List<Movie>>(
            future: MovieService.fetchMoviesTrending(true),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              List<Movie> data = snapshot.data!;
              List<MovieCard> cards = [];
              for (var movie in data) {
                cards.add(
                  MovieCard(
                    movieId: movie.id,
                    title: movie.title,
                    image: movie.image,
                    rating: movie.rating.toStringAsFixed(1),
                    releaseDate: movie.releaseDate,
                    onFavPressed: () async {
                      if (user?.email == null) {
                        CustomDialogs.anonModeDialog(
                          context: context,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      } else {
                        var val = await UserMovies.onFavoriteMoviePressed(
                            movieId: movie.id, userEmail: user?.email);
                        if (!mounted) return;
                        CustomDialogs.favoriteSuccessDialog(
                          context: context,
                          val: val,
                          movie: movie,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }
                    },
                    onPlayPressed: () async {
                      if (user?.email == null) {
                        CustomDialogs.anonModeDialog(
                          context: context,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      } else {
                        var val = await UserMovies.onRecentMoviePressed(
                            movieId: movie.id, userEmail: user?.email);
                        if (!mounted) return;
                        CustomDialogs.recentSuccessDialog(
                          context: context,
                          val: val,
                          movie: movie,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }
                    },
                    onWatchlistPressed: () async {
                      if (user?.email == null) {
                        CustomDialogs.anonModeDialog(
                          context: context,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      } else {
                        var val = await UserMovies.onWatchlistMoviePressed(
                            movieId: movie.id, userEmail: user?.email);
                        if (!mounted) return;
                        CustomDialogs.watchlistSuccessDialog(
                          context: context,
                          val: val,
                          movie: movie,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                );
              }

              return HorizontalListMovies(data: cards);
            },
          ),
          HomeHeader(
            title: 'Continue watching',
            seeAllPressed: () {
              print('Go to Recent :)');
            },
          ),
          FutureBuilder<List<Movie>>(
            future: MovieService.fetchMoviesUserRecent(userEmail: user?.email),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              List<Movie> data = snapshot.data!;
              List<MovieCard> cards = [];

              if (data.isEmpty) {
                return Column(
                  children: const [
                    SizedBox(
                      height: 32.0,
                    ),
                    Text(
                      ". . . nothing here yet :(",
                      style: TextStyle(
                          color: kGreyColor,
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic),
                    ),
                  ],
                );
              } else {
                for (var movie in data) {
                  cards.add(
                    MovieCard(
                      movieId: movie.id,
                      title: movie.title,
                      image: movie.image,
                      rating: movie.rating.toStringAsFixed(1),
                      releaseDate: movie.releaseDate,
                      onFavPressed: () async {
                        var val = await UserMovies.onFavoriteMoviePressed(
                            movieId: movie.id, userEmail: user?.email);
                        if (!mounted) return;
                        CustomDialogs.favoriteSuccessDialog(
                          context: context,
                          val: val,
                          movie: movie,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      onPlayPressed: () async {
                        var val = await UserMovies.onRecentMoviePressed(
                            movieId: movie.id, userEmail: user?.email);
                        if (!mounted) return;
                        CustomDialogs.recentSuccessDialog(
                          context: context,
                          val: val,
                          movie: movie,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                      onWatchlistPressed: () async {
                        var val = await UserMovies.onWatchlistMoviePressed(
                            movieId: movie.id, userEmail: user?.email);
                        if (!mounted) return;
                        CustomDialogs.watchlistSuccessDialog(
                          context: context,
                          val: val,
                          movie: movie,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      },
                    ),
                  );
                }
                return HorizontalListMovies(data: cards);
              }
            },
          ),
          HomeHeader(
            title: 'Top rated movies',
            seeAllPressed: () {
              print('Go to Top Rated :)');
            },
          ),
          FutureBuilder<List<Movie>>(
            future: MovieService.fetchMoviesTopRated(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              List<Movie> data = snapshot.data!;
              List<MovieCard> cards = [];
              for (var movie in data) {
                cards.add(
                  MovieCard(
                    movieId: movie.id,
                    title: movie.title,
                    image: movie.image,
                    rating: movie.rating.toStringAsFixed(1),
                    releaseDate: movie.releaseDate,
                    onFavPressed: () async {
                      if (user?.email == null) {
                        CustomDialogs.anonModeDialog(
                          context: context,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      } else {
                        var val = await UserMovies.onFavoriteMoviePressed(
                            movieId: movie.id, userEmail: user?.email);
                        if (!mounted) return;
                        CustomDialogs.favoriteSuccessDialog(
                          context: context,
                          val: val,
                          movie: movie,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }
                    },
                    onPlayPressed: () async {
                      if (user?.email == null) {
                        CustomDialogs.anonModeDialog(
                          context: context,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      } else {
                        var val = await UserMovies.onRecentMoviePressed(
                            movieId: movie.id, userEmail: user?.email);
                        if (!mounted) return;
                        CustomDialogs.recentSuccessDialog(
                          context: context,
                          val: val,
                          movie: movie,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }
                    },
                    onWatchlistPressed: () async {
                      if (user?.email == null) {
                        CustomDialogs.anonModeDialog(
                          context: context,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      } else {
                        var val = await UserMovies.onWatchlistMoviePressed(
                            movieId: movie.id, userEmail: user?.email);
                        if (!mounted) return;
                        CustomDialogs.watchlistSuccessDialog(
                          context: context,
                          val: val,
                          movie: movie,
                          func: () {
                            setState(
                              () {
                                Navigator.pop(context);
                              },
                            );
                          },
                        );
                      }
                    },
                  ),
                );
              }
              return HorizontalListMovies(data: cards);
            },
          )
        ],
      ),
    );
  }
}

class HorizontalListMovies extends StatelessWidget {
  const HorizontalListMovies({Key? key, required this.data}) : super(key: key);

  final List<Widget> data;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemExtent: 500,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index) {
          return data[index];
        },
      ),
    );
  }
}

class HomeHeader extends StatelessWidget {
  const HomeHeader({Key? key, required this.title, required this.seeAllPressed})
      : super(key: key);

  final String title;
  final Function seeAllPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => seeAllPressed(),
          child: Row(
            children: const [
              Text(
                'See all',
                style: TextStyle(
                  color: kGreyColor,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                width: 4.0,
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: kGreyColor,
                size: 16,
              )
            ],
          ),
        ),
      ],
    );
  }
}
