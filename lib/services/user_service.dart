import '../models/user.dart';

class UserService {
  static List<User> getMockUsers() {
    return [
      User(
        id: '1',
        name: 'Alex Johnson',
        username: '@alexj',
        bio: 'Fitness enthusiast 💪 | Running marathons',
        followersCount: 1234,
        followingCount: 567,
        completedChallengesCount: 89,
      ),
      User(
        id: '2',
        name: 'Maria Garcia',
        username: '@mariag',
        bio: 'Learning something new every day 📚',
        followersCount: 892,
        followingCount: 423,
        completedChallengesCount: 145,
      ),
      User(
        id: '3',
        name: 'James Chen',
        username: '@jameschen',
        bio: 'Mindfulness practitioner 🧘 | Yoga lover',
        followersCount: 2341,
        followingCount: 891,
        completedChallengesCount: 203,
      ),
      User(
        id: '4',
        name: 'Sophie Williams',
        username: '@sophiew',
        bio: 'Creative soul 🎨 | Digital artist',
        followersCount: 4567,
        followingCount: 1234,
        completedChallengesCount: 178,
      ),
      User(
        id: '5',
        name: 'David Kim',
        username: '@davidk',
        bio: 'Productivity geek ⚡ | Building better habits',
        followersCount: 3421,
        followingCount: 987,
        completedChallengesCount: 267,
      ),
      User(
        id: '6',
        name: 'Emma Brown',
        username: '@emmab',
        bio: 'Social butterfly 🦋 | Community builder',
        followersCount: 1876,
        followingCount: 1543,
        completedChallengesCount: 112,
      ),
      User(
        id: '7',
        name: 'Lucas Silva',
        username: '@lucass',
        bio: 'Health coach 🏥 | Nutrition expert',
        followersCount: 5432,
        followingCount: 2345,
        completedChallengesCount: 389,
      ),
      User(
        id: '8',
        name: 'Olivia Taylor',
        username: '@oliviat',
        bio: 'Book lover 📖 | Lifelong learner',
        followersCount: 987,
        followingCount: 654,
        completedChallengesCount: 156,
      ),
    ];
  }
}

