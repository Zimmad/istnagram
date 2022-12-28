import 'package:flutter/foundation.dart' show immutable;

@immutable
class Strings {
  const Strings._();
  static const appName = 'InstnaGram';
  static const welcomeToAppName = 'Welcome to ${Strings.appName}';
  static const youHaveNoPosts =
      'You haven\'t uploaded any post yet. To upload a post, Click on the "Upload Pic" or "Upload Video" on the top  ';
  static const noPostsAvailable =
      'Nobody seems to have made any post yet. Why don\'t you take the first step and upload your first post! ';
  static const enterYouSearchTerm =
      'Enter your search item in order to get started, you can search in the discription of all posts available in the system.';

  static const facebook = 'Facebook';
  static const facebookSignupUrl = 'https://www.facebook.com/signup';
  static const google = 'Google';
  static const googleSignupUrl = 'https://accounts.google.com/signup';
  static const logIntoYourAccount =
      'Log into your account using one of the options below.';
  static const comments = 'Comments';
  static const writeYourCommentHere = 'Write your comment here...';
  static const checkOutThisPost = 'Check out this post!';
  static const postDetails = 'Post Details';
  static const post = 'post';

  static const createNewPost = 'Create New Post';
  static const pleaseWriteYourMessageHere = 'Please write your message here';

  static const noCommentsYet =
      'Nobody has commented on this post yet. You can change that though, and be the first person who comments!';

  static const enterYourSearchTermHere = 'Enter your search term here';

  // login view rich text at bottom
  static const dontHaveAnAccount = "Don't have an account?\n";
  static const signUpOn = 'Sign up on ';
  static const orCreateAnAccountOn = ' or create an account on ';
}
