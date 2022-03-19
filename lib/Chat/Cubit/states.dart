abstract class SocialStates {}

class SocialInitialStates extends SocialStates {}

class SocialGetUserLoadingStates extends SocialStates {}

class SocialGetUserSuccessStates extends SocialStates {}

class SocialGetUserErrorStates extends SocialStates {
  final String error;

  SocialGetUserErrorStates(this.error);
}

class SocialGetAllUserLoadingStates extends SocialStates {}

class SocialGetAllUserSuccessStates extends SocialStates {}

class SocialGetAllUserErrorStates extends SocialStates {
  final String error;

  SocialGetAllUserErrorStates(this.error);
}

class SocialChangeBottomNavStates extends SocialStates {}

class SocialNewPostStates extends SocialStates {}

class SocialImagePickedProfileSuccessStates extends SocialStates {}

class SocialImagePickedProfileErrorStates extends SocialStates {}

class SocialImagePickedCoverSuccessStates extends SocialStates {}

class SocialImagePickedCoverErrorStates extends SocialStates {}

class SocialUploadImageProfileSuccessStates extends SocialStates {}

class SocialUploadImageProfileErrorStates extends SocialStates {}

class SocialUploadImageProfileLoadingStates extends SocialStates {}

class SocialUploadImageCoverSuccessStates extends SocialStates {}

class SocialUploadImageCoverErrorStates extends SocialStates {}

class SocialUploadImageCoverLoadingStates extends SocialStates {}

class SocialUpdateImageStates extends SocialStates {}

class SocialUpdateUserLoadingStates extends SocialStates {}

class SocialUpdateCoverStates extends SocialStates {}

class SocialPostLoadingStates extends SocialStates {}

class SocialPostSuccessStates extends SocialStates {}

class SocialPostErrorStates extends SocialStates {}

class SocialImagePickedPostSuccessStates extends SocialStates {}

class SocialPostLikeSuccessState extends SocialStates {}

class SocialPostDisLikeSuccessState extends SocialStates {}

class SocialGetLikeSuccessState extends SocialStates {}

class SocialGetLikeBoolLoadingState extends SocialStates {}

class SocialGetLikeBoolSuccessState extends SocialStates {}

class SocialGetLikeBoolErrorState extends SocialStates {}

class SocialPostLikeErrorState extends SocialStates {}

class SocialImagePickedPostErrorStates extends SocialStates {}

class SocialImageCloseStates extends SocialStates {}

class SocialGetPostsLoadingStates extends SocialStates {}

class SocialGetPostsSuccessStates extends SocialStates {}

class SocialGetPostsErrorStates extends SocialStates {
  final String error;

  SocialGetPostsErrorStates(this.error);
}

class SocialSendMessageSuccessStates extends SocialStates {}

class SocialSendMessageErrorStates extends SocialStates {
  final String error;

  SocialSendMessageErrorStates(this.error);
}

class SocialGetMessageLoadingStates extends SocialStates {}

class SocialGetMessageSuccessStates extends SocialStates {}

class SocialGetMessageErrorStates extends SocialStates {
  final String error;

  SocialGetMessageErrorStates(this.error);
}

class SocialGetContactsSuccessStates extends SocialStates {}

class SocialChangeLTRSuccessStates extends SocialStates {}

class SocialUploadFileSuccessStates extends SocialStates {}

class SocialUploadFileErrorStates extends SocialStates {}

class SocialUploadFileLoadingStates extends SocialStates {}

class SocialDownLoadFileLoadingStates extends SocialStates {}

class SocialDownLoadFileSavedStates extends SocialStates {}

class SocialDownLoadFileSavedErrorStates extends SocialStates {}

class SocialChangeFontSuccessStates extends SocialStates {}
