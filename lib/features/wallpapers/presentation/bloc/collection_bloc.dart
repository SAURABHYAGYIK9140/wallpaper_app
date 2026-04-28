import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/wallpaper_entity.dart';
import '../../domain/usecases/add_to_collection.dart';
import '../../domain/usecases/get_collection.dart';
import '../../domain/usecases/is_in_collection.dart';
import '../../domain/usecases/remove_from_collection.dart';

// Events
abstract class CollectionEvent extends Equatable {
  const CollectionEvent();
  @override
  List<Object> get props => [];
}

class AddToCollectionEvent extends CollectionEvent {
  final WallpaperEntity wallpaper;
  const AddToCollectionEvent(this.wallpaper);
  @override
  List<Object> get props => [wallpaper];
}

class RemoveFromCollectionEvent extends CollectionEvent {
  final int id;
  const RemoveFromCollectionEvent(this.id);
  @override
  List<Object> get props => [id];
}

class GetCollectionEvent extends CollectionEvent {}

class CheckIfInCollectionEvent extends CollectionEvent {
  final int id;
  const CheckIfInCollectionEvent(this.id);
  @override
  List<Object> get props => [id];
}

// Unified State
class CollectionState extends Equatable {
  final List<WallpaperEntity> wallpapers;
  final bool isInCollection;
  final int? checkedId;
  final bool isLoading;
  final String? error;

  const CollectionState({
    this.wallpapers = const [],
    this.isInCollection = false,
    this.checkedId,
    this.isLoading = false,
    this.error,
  });

  CollectionState copyWith({
    List<WallpaperEntity>? wallpapers,
    bool? isInCollection,
    int? checkedId,
    bool? isLoading,
    String? error,
  }) {
    return CollectionState(
      wallpapers: wallpapers ?? this.wallpapers,
      isInCollection: isInCollection ?? this.isInCollection,
      checkedId: checkedId ?? this.checkedId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [wallpapers, isInCollection, checkedId, isLoading, error];
}

// Bloc
class CollectionBloc extends Bloc<CollectionEvent, CollectionState> {
  final AddToCollection addToCollection;
  final RemoveFromCollection removeFromCollection;
  final GetCollection getCollection;
  final IsInCollection isInCollection;

  CollectionBloc({
    required this.addToCollection,
    required this.removeFromCollection,
    required this.getCollection,
    required this.isInCollection,
  }) : super(const CollectionState()) {
    
    on<AddToCollectionEvent>((event, emit) async {
      try {
        await addToCollection(event.wallpaper);
        emit(state.copyWith(isInCollection: true, checkedId: event.wallpaper.id));
        add(GetCollectionEvent()); // Refresh list
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });

    on<RemoveFromCollectionEvent>((event, emit) async {
      try {
        await removeFromCollection(event.id);
        emit(state.copyWith(isInCollection: false, checkedId: event.id));
        add(GetCollectionEvent()); // Refresh list
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });

    on<GetCollectionEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final wallpapers = await getCollection();
        emit(state.copyWith(wallpapers: wallpapers, isLoading: false));
      } catch (e) {
        emit(state.copyWith(error: e.toString(), isLoading: false));
      }
    });

    on<CheckIfInCollectionEvent>((event, emit) async {
      try {
        final isContained = await isInCollection(event.id);
        emit(state.copyWith(isInCollection: isContained, checkedId: event.id));
      } catch (e) {
        emit(state.copyWith(error: e.toString()));
      }
    });
  }
}
