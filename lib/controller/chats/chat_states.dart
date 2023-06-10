abstract class ChatStates {}

class InitialState extends ChatStates {}

class AutoScrollChatListState extends ChatStates {}

class GetSelectedUserLoadingState extends ChatStates {}

class GetSelectedUserSuccessState extends ChatStates {}

class GetSelectedUserErrorState extends ChatStates {
  final String error;

  GetSelectedUserErrorState(this.error);
}

class SendMessageLoadingState extends ChatStates {}

class SendMessageSuccessState extends ChatStates {}

class SendMessageErrorState extends ChatStates {
  final String error;

  SendMessageErrorState(this.error);
}

class GetMessageLoadingState extends ChatStates {}

class GetMessageSuccessState extends ChatStates {}
