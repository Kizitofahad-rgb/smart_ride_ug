/// Represents a searchable destination (an area or landmark a
/// passenger might want to travel to).
///
/// This is deliberately its own model, separate from `BusStop`. A
/// destination is what the passenger *searches for* — it may not
/// correspond to an exact stop yet (e.g. "Kampala Road" vs the stop
/// named "City Centre"). Keeping them separate now avoids forcing a
/// premature 1:1 mapping that Firestore data may not actually have.
class Destination {
  const Destination({
    required this.id,
    required this.name,
    required this.area,
  });

  final String id;
  final String name;
  final String area;
}