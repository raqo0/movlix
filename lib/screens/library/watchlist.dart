import 'package:flutter/material.dart';
import 'package:movlix/models/movie.dart';
import 'package:movlix/models/my_app_user.dart';
import 'package:movlix/models/user_movies.dart';
import 'package:movlix/services/movie_service.dart';
import 'package:movlix/widgets/custom_dialogs.dart';
import 'package:movlix/widgets/default_movie_view.dart';
import 'package:movlix/widgets/movie_card.dart';
import 'package:movlix/widgets/movie_sliver_grid.dart';
import 'package:provider/provider.dart';

class Watchlist extends StatefulWidget {
  const Watchlist({Key? key}) : super(key: key);

  @override
  State<Watchlist> createState() => _WatchlistState();
}

class _WatchlistState extends State<Watchlist> {
  @override
  Widget build(BuildContext context) {
    final MyAppUser? user = Provider.of<MyAppUser?>(context);

    return DefaultMovieView(
      title: 'Watchlist',
      futureData: FutureBuilder<List<Movie>>(
        future: MovieService.fetchMoviesUserWatchlist(userEmail: user?.email),
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.connectionState == ConnectionState.waiting) {
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
          return MovieSliverGrid(data: cards);
        },
      ),
    );
  }
}
