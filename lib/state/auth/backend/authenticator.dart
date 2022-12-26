import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:istnagram/state/auth/constants/constants.dart';
import 'package:istnagram/state/auth/models/auth_result.dart';

import '../../posts/typedef/user_id.dart';

/// This class contains the core of authentication.
class Authenticator {
  const Authenticator();

  /// if the user have current userId than it means you are already loged in
  UserId? get userId => FirebaseAuth.instance.currentUser?.uid;
  bool get isAlreadyLoggedIn => userId != null;
  String get displayName =>
      FirebaseAuth.instance.currentUser?.displayName ?? '';
  String? get email => FirebaseAuth.instance.currentUser?.email;

  /// [loggedOut], [loggedInWithFacebook], [loggedInWithGoogle]
  Future<void> loggedOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await FacebookAuth.instance.logOut();
  }

  Future<AuthResult> loginWithFacebook() async {
    /// If the user will do this , the entire log in dialog for facebook will appear here.
    /// this will dispaly facebook log in dialog
    final loginResult = await FacebookAuth.instance
        .login(); // from this login result we are going to get the user token

    /// In order to see if the user have logged in or cancel the facebook login dialog, we are going to check for the login token.
    final token = loginResult.accessToken?.token;

    ///if the user has aborted the logging process.
    if (token == null) {
      return AuthResult.aborted;
    }

    /// the user enter his credentials
    final oAuthCradentials = FacebookAuthProvider.credential(token);

    try {
      await FirebaseAuth.instance.signInWithCredential(oAuthCradentials);
      return AuthResult.success;
    } on FirebaseAuthException catch (e) {
      // the error could be that the account exists with different cradentials
      // with Fedrated sign in the problem is that if you are signed in with
      // google and you loged out and then you try to log in with facebook with
      // the exact same cradentials you are going to get an exception

      /// we extract the email
      final email = e.email;
      final credential = e.credential;
      if (e.code == Constants.accountExistsWithDifferentCredentials &&
          email != null &&
          credential != null) {
        ///  [provider] can be Google or Facebook
        final provider =
            await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
        if (provider.contains(Constants.googleCom)) {
          /// if you have already logged in with the same emil using goolge, than we refer you to [loginWithGoogle]
          await loginWithGoogle();

          /// If the google logging in with the same credentials goes successfully then we
          /// link these two credentials.
          FirebaseAuth.instance.currentUser?.linkWithCredential(credential);
        }
        return AuthResult.success;
      }
      return AuthResult.failure;
    }
  }

  /// logging in user with google fedrated logging in
  Future<AuthResult> loginWithGoogle() async {
    final GoogleSignIn googleSignIn =
        GoogleSignIn(scopes: [Constants.emailScope]);

    ///This will display the google sign in dialog
    final signInAccount = await googleSignIn.signIn();
    if (signInAccount == null) {
      return AuthResult.aborted;
    }

    final googleAuth = await signInAccount.authentication;
    final oAuthcredentials = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      accessToken: googleAuth.accessToken,
    );

    /// We gives these [credentials] to the firebase in the exact same way as we did for facebook
    try {
      await FirebaseAuth.instance.signInWithCredential(oAuthcredentials);
      return AuthResult.success;

      // } on FirebaseAuthException catch (e) {  return AuthResult.failure;}
    } catch (e) {
      return AuthResult.failure;
    }
  }
}
