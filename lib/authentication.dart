import "package:firebase_auth/firebase_auth.dart";
import "package:google_sign_in/google_sign_in.dart";


final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();



Future<FirebaseUser> signInWithGoogle() async {
  // Attempt to get the currently authenticated user
  GoogleSignInAccount currentUser = _googleSignIn.currentUser;
  if (currentUser == null) {
    // Attempt to sign in without user interaction
    currentUser = await _googleSignIn.signInSilently();
  }
  if (currentUser == null) {
    // Force the user to interactively sign in
    currentUser = await _googleSignIn.signIn();
  }

  final GoogleSignInAuthentication auth = await currentUser.authentication;
  final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );

  // Authenticate with firebase
  final FirebaseUser user = await _auth.signInWithCredential(credential);
 
  

  assert(user != null);
  assert(!user.isAnonymous);

  return user;
}


Future<Null> signOutWithGoogle() async {
  // Sign out with firebase
  await _auth.signOut();
  // Sign out with google
  await _googleSignIn.signOut();
}
