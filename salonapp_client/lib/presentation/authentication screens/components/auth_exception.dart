class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure(
      [this.message = "An Unknown error occured!!"]);

  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignUpWithEmailAndPasswordFailure(
            'Enter a strong password.');
      case 'invalid-email':
        return const SignUpWithEmailAndPasswordFailure(
            'Email is not valid or badly formatted');
      case 'email-already-in-use':
        return const SignUpWithEmailAndPasswordFailure(
            'An account already exist for that email.');
      case 'operation-not-allowed':
        return const SignUpWithEmailAndPasswordFailure(
            'Operation is not allowed. Please contact Support.');
      case 'user-disabled':
        return const SignUpWithEmailAndPasswordFailure(
            'This user has being disabled. Please Contact Support for help.');
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}
