import 'package:flutter/foundation.dart';

// ─── CHILD ───
class Child {
  final String id;
  final String name;
  final DateTime? dob;
  final String emoji;

  const Child({required this.id, required this.name, this.dob, required this.emoji});

  String get ageBand {
    if (dob == null) return 'Child';
    final months = DateTime.now().difference(dob!).inDays ~/ 30;
    if (months < 12) return '${months}mo';
    final years = months ~/ 12;
    return '$years yr${years != 1 ? "s" : ""}';
  }

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'dob': dob?.toIso8601String(), 'emoji': emoji};

  factory Child.fromMap(Map<String, dynamic> m) => Child(
    id: m['id'] as String,
    name: m['name'] as String,
    dob: m['dob'] != null ? DateTime.tryParse(m['dob'] as String) : null,
    emoji: m['emoji'] as String? ?? '🐻',
  );
}

// ─── HABIT ───
class Habit {
  final String id;
  final String name;
  bool done;
  int streak;

  Habit({required this.id, required this.name, this.done = false, this.streak = 0});

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'done': done, 'streak': streak};

  factory Habit.fromMap(Map<String, dynamic> m) => Habit(
    id: m['id'] as String,
    name: m['name'] as String,
    done: m['done'] as bool? ?? false,
    streak: m['streak'] as int? ?? 0,
  );
}

// ─── SAVED ITEM ───
class SavedItem {
  final String id;
  final String type; // Story | Recipe | Activity
  final String name;
  final DateTime savedAt;

  SavedItem({required this.id, required this.type, required this.name, required this.savedAt});

  Map<String, dynamic> toMap() => {'id': id, 'type': type, 'name': name, 'savedAt': savedAt.toIso8601String()};

  factory SavedItem.fromMap(Map<String, dynamic> m) => SavedItem(
    id: m['id'] as String, type: m['type'] as String,
    name: m['name'] as String, savedAt: DateTime.parse(m['savedAt'] as String),
  );
}

// ─── STORY ───
class Story {
  final String id;
  final String title;
  final String body;
  final String emoji;
  final String theme;
  final String childName;
  final DateTime createdAt;

  Story({required this.id, required this.title, required this.body,
      required this.emoji, required this.theme, required this.childName,
      required this.createdAt});

  Map<String, dynamic> toMap() => {
    'id': id, 'title': title, 'body': body, 'emoji': emoji,
    'theme': theme, 'childName': childName, 'createdAt': createdAt.toIso8601String(),
  };

  factory Story.fromMap(Map<String, dynamic> m) => Story(
    id: m['id'] as String, title: m['title'] as String, body: m['body'] as String,
    emoji: m['emoji'] as String? ?? '🌙', theme: m['theme'] as String? ?? '',
    childName: m['childName'] as String? ?? '', createdAt: DateTime.parse(m['createdAt'] as String),
  );
}

// ─── RECIPE ───
class Recipe {
  final String emoji;
  final String name;
  final List<String> tags;
  final String time;
  final String serves;
  final String age;
  final List<String> steps;

  const Recipe({required this.emoji, required this.name, required this.tags,
      required this.time, required this.serves, required this.age, required this.steps});
}

// ─── ACTIVITY ───
class Activity {
  final String emoji;
  final String name;
  final String category;
  final List<String> tags;
  final String description;
  final List<String> steps;
  final bool isPrintable;

  const Activity({required this.emoji, required this.name, required this.category,
      required this.tags, required this.description, required this.steps,
      this.isPrintable = false});
}

// ─── CIRCLE ───
class CircleGroup {
  final String id;
  final String emoji;
  final String name;
  final String meta;
  final List<String> memberInitials;
  final int memberCount;
  final List<CirclePost> posts;
  final Playdate? playdate;

  const CircleGroup({required this.id, required this.emoji, required this.name,
      required this.meta, required this.memberInitials, required this.memberCount,
      required this.posts, this.playdate});
}

class CirclePost {
  final String author;
  final String text;
  final String time;
  const CirclePost({required this.author, required this.text, required this.time});
}

class Playdate {
  final String title;
  final String when;
  const Playdate({required this.title, required this.when});
}

// ─── STATIC CONTENT ──────────────────────────────────────────────────────────
class TContent {
  static const themes = [
    'Magic forest', 'Space odyssey', 'Ocean friends', 'Dragon quest',
    'Friendship', 'Sleepy meadow', 'Adventure time', 'Cozy winter',
  ];

  static const themeEmojis = {
    'Magic forest': '🌲', 'Space odyssey': '🚀', 'Ocean friends': '🐳',
    'Dragon quest': '🐉', 'Friendship': '🤝', 'Sleepy meadow': '🌙',
    'Adventure time': '⚡', 'Cozy winter': '❄️',
  };

  static const goals = [
    'Bedtime routine', 'Picky eating', 'Screen-free time', 'Learning & play',
    'Family bonding', 'Health tracking', 'Stay organised', 'New siblings',
  ];

  static const emojis = ['🐻','🦁','🐼','🐨','🦊','🐸','🦋','🌟','🌈','🐬'];

  static const recipes = [
    Recipe(emoji: '🥞', name: 'Sneaky Veggie Pancakes',
        tags: ['Breakfast', 'Under 20 min', 'Ages 2+'],
        time: '18 min', serves: '8 pancakes', age: 'Ages 2+',
        steps: ['Mix 1 cup flour, 1 egg, ¾ cup milk and a pinch of salt.',
                'Grate ½ a courgette and squeeze out extra water.',
                'Stir courgette into the batter.',
                'Cook small circles on a buttered pan, 2 min each side.',
                'Serve with a drizzle of honey.']),
    Recipe(emoji: '🍝', name: 'Hidden Carrot Pasta',
        tags: ['Dinner', '30 min', 'Picky-eater favourite'],
        time: '28 min', serves: '4 portions', age: 'Ages 1+',
        steps: ['Boil pasta until soft.',
                'Sauté onion and 2 carrots in olive oil until tender.',
                'Blend carrots with tinned tomatoes into a smooth sauce.',
                'Toss pasta in the sauce.',
                'Top with a little grated cheese.']),
    Recipe(emoji: '🧁', name: 'Banana Oat Muffins',
        tags: ['Snack', '25 min', 'No added sugar'],
        time: '25 min', serves: '12 muffins', age: 'Ages 1+',
        steps: ['Mash 3 ripe bananas in a bowl.',
                'Stir in 2 cups oats, 2 eggs, and ½ tsp cinnamon.',
                'Spoon into a greased muffin tray.',
                'Bake at 180°C for 18–20 minutes.',
                'Cool before serving.']),
    Recipe(emoji: '🥗', name: 'Rainbow Rice Bowl',
        tags: ['Lunch', '15 min', 'Ages 3+'],
        time: '15 min', serves: '2 portions', age: 'Ages 3+',
        steps: ['Cook rice or use leftover rice.',
                'Dice cucumber, cherry tomatoes, and corn.',
                'Arrange colourfully over rice.',
                'Drizzle with mild sesame dressing.',
                'Let your child mix it themselves — they eat more!']),
  ];

  static const activities = [
    Activity(emoji: '🖍️', name: 'Name Coloring Sheet', category: 'Coloring',
        tags: ['Ages 3–8', '15 min', 'Printable'],
        description: 'A personalised coloring sheet where your child\'s name forms the outline — every letter becomes a picture to color in.',
        steps: ['Download the personalised sheet below.', 'Print on A4 paper.',
                'Hand over the crayons and let them go!', 'Display on the fridge when done 🎨'],
        isPrintable: true),
    Activity(emoji: '🌿', name: 'Nature Scavenger Hunt', category: 'Outdoors',
        tags: ['Ages 4–10', '45 min', 'Free'],
        description: 'A backyard or park adventure. Kids find items from a checklist — great for attention, observation, and getting outside.',
        steps: ['Print or read out the list: leaf, pebble, feather, flower, bug, bark.',
                'Set a 30-minute timer.', 'Each found item earns a point.',
                'Bonus: photograph everything found!']),
    Activity(emoji: '🎭', name: 'Sock Puppet Theatre', category: 'Craft',
        tags: ['Ages 3–7', '30 min', 'Craft'],
        description: 'Transform old socks into characters and put on a family show.',
        steps: ['Grab 2–4 old socks.', 'Use buttons, felt, and markers to make faces.',
                'Give each puppet a name and voice.', 'Perform a 2-minute story for the family!']),
    Activity(emoji: '🧪', name: 'Baking Soda Volcano', category: 'Science',
        tags: ['Ages 5–10', '20 min', 'Science'],
        description: 'The classic kitchen experiment. Mix baking soda and vinegar for a fizzy eruption.',
        steps: ['Build a mountain shape from salt dough or clay.',
                'Place a small cup in the top.',
                'Add 2 tbsp baking soda and red food colouring.',
                'Pour in vinegar and watch it erupt!']),
  ];

  static const activityCategories = ['All', 'Coloring', 'Outdoors', 'Craft', 'Science'];

  static const circles = [
    CircleGroup(id: 'c1', emoji: '🏫', name: 'Sunshine Preschool',
        meta: 'Class of Bluejays · 12 parents',
        memberInitials: ['PR', 'SM', 'AK'], memberCount: 12,
        playdate: Playdate(title: 'Playdate at Riverside Park', when: 'Sat 7 Jun · 10am – 12pm'),
        posts: [
          CirclePost(author: 'Sarah M.', text: 'Reminder: World Book Day costumes needed Friday! 📚', time: '2h ago'),
          CirclePost(author: 'Ananya K.', text: 'Anyone want to carpool to the nature walk on Thursday?', time: '5h ago'),
        ]),
    CircleGroup(id: 'c2', emoji: '👨‍👩‍👧', name: 'Our Family',
        meta: 'Co-parents & grandparents · 4 members',
        memberInitials: ['P', 'S', 'G'], memberCount: 4,
        posts: [
          CirclePost(author: 'Grandma Nita', text: 'Loved the video of the first bike ride! Send more 🥰', time: 'Yesterday'),
          CirclePost(author: 'Suresh', text: 'I\'ll do school pickup Tuesday — can you do Wednesday?', time: 'Yesterday'),
        ]),
  ];

  static List<Habit> defaultHabits() => [
    Habit(id: '1', name: 'Bedtime story', streak: 3),
    Habit(id: '2', name: 'Tidy up toys', streak: 1),
    Habit(id: '3', name: 'Family dinner', streak: 5),
  ];
}
