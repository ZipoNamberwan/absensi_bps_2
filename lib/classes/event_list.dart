class MapEvent<T> {
  Map<DateTime, List<T>> events;

  MapEvent({
    this.events,
  });

  void add(DateTime date, T event) {
    if (events == null)
      events = {
        date: [event]
      };
    else if (!events.containsKey(date))
      events[date] = [event];
    else
      events[date].add(event);
  }

  void addAll(DateTime date, List<T> events) {
    if (this.events == null)
      this.events = {date: events};
    else if (!this.events.containsKey(date))
      this.events[date] = events;
    else
      this.events[date].addAll(events);
  }

  void addAllMaps(MapEvent<T> map) {}

  bool remove(DateTime date, T event) {
    return events != null && events.containsKey(date)
        ? events[date].remove(event)
        : true;
  }

  List<T> removeAll(DateTime date) {
    return events != null && events.containsKey(date)
        ? events.remove(date)
        : [];
  }

  void clear() {
    if (events != null) {
      events.clear();
    } else {
      events = {};
    }
  }

  List<T> getEvents(DateTime date) {
    return events != null && events.containsKey(date) ? events[date] : [];
  }
}

class MapList<T> {
  Map<String, T> maps;

  MapList({
    this.maps,
  });

  void add(String id, T object) {
    if (maps == null)
      maps = {id: object};
    else
      maps[id] = object;
  }
}

class MapPegawaiEvent<T> {
  Map<String, MapEvent<T>> maps;

  MapPegawaiEvent({
    this.maps,
  });

  void add(String id, MapEvent<T> object) {
    if (maps == null)
      maps = {id: object};
    else if (!maps.containsKey(id)) {
      maps[id] = object;
    } else {
      maps[id].events.addAll(object.events);
    }
  }

  bool isMapsNull(String id) {
    if (maps == null) {
      return true;
    } else {
      if (maps.containsKey(id))
        return false;
      else
        return true;
    }
  }
}
