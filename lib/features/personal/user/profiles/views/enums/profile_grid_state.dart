enum ProfileGridState {
  initial,
  loading,
  loaded,
  empty,
  error;

  bool get isLoading => this == ProfileGridState.loading;
  bool get isLoaded => this == ProfileGridState.loaded;
  bool get isEmpty => this == ProfileGridState.empty;
  bool get isError => this == ProfileGridState.error;
  bool get isInitial => this == ProfileGridState.initial;
}
