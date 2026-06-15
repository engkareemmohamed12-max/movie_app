abstract class BrowseStates {}


class BrowseInitialState extends BrowseStates{}

class BrowseLoadingState extends BrowseStates {}

class BrowseSuccessState extends BrowseStates {}

class BrowseErrorState extends BrowseStates {

  final String error;

  BrowseErrorState(this.error);
}