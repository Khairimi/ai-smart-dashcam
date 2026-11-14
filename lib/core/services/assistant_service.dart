/// Source of Nexio AI replies. Only a simulated implementation exists; no
/// real language model is connected.
abstract interface class AssistantService {
  Future<String> reply(String prompt);
}
