// ─────────────────────────────────────────────
// ENUMS
// ─────────────────────────────────────────────

enum UserRole { student, admin, clubLead, eventOrganizer }
enum EventCategory { academic, social, sports, tech, cultural, career }
enum PostType { text, image, poll, announcement }
enum MessageStatus { sent, delivered, read }
enum ClubCategory { tech, arts, sports, academic, social, business }

// ─────────────────────────────────────────────
// MODELS
// ─────────────────────────────────────────────

class UserModel {
  final String id;
  final String username;
  final String email;
  final String password;
  final String fullName;
  final String avatarUrl;
  final String campus;
  final String department;
  final String yearOfStudy;
  final UserRole role;
  final bool isOnline;
  final List<String> clubIds;
  final List<String> eventIds;
  final List<String> friendIds;
  final List<String> postIds;
  final Map<String, dynamic> metadata;

  const UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    required this.avatarUrl,
    required this.campus,
    required this.department,
    required this.yearOfStudy,
    required this.role,
    required this.isOnline,
    required this.clubIds,
    required this.eventIds,
    required this.friendIds,
    required this.postIds,
    required this.metadata,
  });
}

class EventModel {
  final String id;
  final String title;
  final String description;
  final String organizerId;
  final String clubId;
  final EventCategory category;
  final String location;
  final String campus;
  final DateTime startDate;
  final DateTime endDate;
  final String bannerUrl;
  final int maxAttendees;
  final List<String> attendeeIds;
  final bool isPublic;
  final String rsvpStatus; // "going" | "interested"
  final Map<String, dynamic> metadata;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.organizerId,
    required this.clubId,
    required this.category,
    required this.location,
    required this.campus,
    required this.startDate,
    required this.endDate,
    required this.bannerUrl,
    required this.maxAttendees,
    required this.attendeeIds,
    required this.isPublic,
    required this.rsvpStatus,
    required this.metadata,
  });
}

class ClubModel {
  final String id;
  final String name;
  final String description;
  final String leaderId;
  final ClubCategory category;
  final String campus;
  final String logoUrl;
  final List<String> memberIds;
  final List<String> eventIds;
  final bool isVerified;
  final Map<String, dynamic> metadata;

  const ClubModel({
    required this.id,
    required this.name,
    required this.description,
    required this.leaderId,
    required this.category,
    required this.campus,
    required this.logoUrl,
    required this.memberIds,
    required this.eventIds,
    required this.isVerified,
    required this.metadata,
  });
}

class PostModel {
  final String id;
  final String authorId;
  final String content;
  final PostType type;
  final List<String> imageUrls;
  final List<String> likeIds;
  final List<CommentModel> comments;
  final String? clubId;
  final String? eventId;
  final bool isPinned;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic> metadata;

  const PostModel({
    required this.id,
    required this.authorId,
    required this.content,
    required this.type,
    required this.imageUrls,
    required this.likeIds,
    required this.comments,
    this.clubId,
    this.eventId,
    required this.isPinned,
    required this.createdAt,
    required this.updatedAt,
    required this.metadata,
  });
}

class CommentModel {
  final String id;
  final String authorId;
  final String content;
  final List<String> likeIds;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const CommentModel({
    required this.id,
    required this.authorId,
    required this.content,
    required this.likeIds,
    required this.createdAt,
    required this.metadata,
  });
}

class MessageModel {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final MessageStatus status;
  final DateTime sentAt;
  final bool isDeleted;
  final Map<String, dynamic> metadata;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.status,
    required this.sentAt,
    required this.isDeleted,
    required this.metadata,
  });
}

class ChatThreadModel {
  final String id;
  final List<String> participantIds;
  final List<MessageModel> messages;
  final DateTime lastActivity;
  final Map<String, dynamic> metadata;

  const ChatThreadModel({
    required this.id,
    required this.participantIds,
    required this.messages,
    required this.lastActivity,
    required this.metadata,
  });
}

class NotificationModel {
  final String id;
  final String userId;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final Map<String, dynamic> metadata;

  const NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    required this.metadata,
  });
}

// ─────────────────────────────────────────────
// DATABASE
// ─────────────────────────────────────────────

class DummyDatabase {

  // ── USERS ──────────────────────────────────

  static final List<UserModel> users = [
    UserModel(
      id: 'usr_001',
      username: 'aline.umuhoza',
      email: 'aline.umuhoza@kigali.edu',
      password: 'Aline@2024',
      fullName: 'Aline Umuhoza',
      avatarUrl: 'https://i.pravatar.cc/150?img=47',
      campus: 'Kigali Campus',
      department: 'Computer Science',
      yearOfStudy: 'Year 3',
      role: UserRole.student,
      isOnline: true,
      clubIds: ['clb_001', 'clb_003'],
      eventIds: ['evt_001', 'evt_002', 'evt_005'],
      friendIds: ['usr_002', 'usr_003', 'usr_004'],
      postIds: ['pst_001', 'pst_003'],
      metadata: {
        'createdAt': '2022-09-01T08:00:00Z',
        'updatedAt': '2024-11-15T10:30:00Z',
        'connects': 87,
        'bio': 'CS student passionate about AI and design.',
        'linkedIn': 'linkedin.com/in/aline-umuhoza',
        'isVerified': true,
        'lastSeen': '2024-11-20T09:15:00Z',
      },
    ),
    UserModel(
      id: 'usr_002',
      username: 'eric.mugisha',
      email: 'eric.mugisha@kigali.edu',
      password: 'Eric@2024',
      fullName: 'Eric Mugisha',
      avatarUrl: 'https://i.pravatar.cc/150?img=12',
      campus: 'Kigali Campus',
      department: 'Business Administration',
      yearOfStudy: 'Year 2',
      role: UserRole.clubLead,
      isOnline: false,
      clubIds: ['clb_002'],
      eventIds: ['evt_001', 'evt_003'],
      friendIds: ['usr_001', 'usr_005'],
      postIds: ['pst_002'],
      metadata: {
        'createdAt': '2023-01-15T08:00:00Z',
        'updatedAt': '2024-10-10T11:00:00Z',
        'connects': 54,
        'bio': 'Entrepreneur and club leader.',
        'linkedIn': 'linkedin.com/in/eric-mugisha',
        'isVerified': true,
        'lastSeen': '2024-11-19T18:45:00Z',
      },
    ),
    UserModel(
      id: 'usr_003',
      username: 'grace.uwase',
      email: 'grace.uwase@kigali.edu',
      password: 'Grace@2024',
      fullName: 'Grace Uwase',
      avatarUrl: 'https://i.pravatar.cc/150?img=32',
      campus: 'Huye Campus',
      department: 'Medicine',
      yearOfStudy: 'Year 4',
      role: UserRole.student,
      isOnline: true,
      clubIds: ['clb_003'],
      eventIds: ['evt_002', 'evt_004'],
      friendIds: ['usr_001', 'usr_004'],
      postIds: ['pst_004'],
      metadata: {
        'createdAt': '2021-09-01T08:00:00Z',
        'updatedAt': '2024-11-01T09:00:00Z',
        'connects': 112,
        'bio': 'Future doctor. Love research and community health.',
        'linkedIn': '',
        'isVerified': false,
        'lastSeen': '2024-11-20T07:00:00Z',
      },
    ),
    UserModel(
      id: 'usr_004',
      username: 'patrick.nkurunziza',
      email: 'patrick.nkurunziza@kigali.edu',
      password: 'Patrick@2024',
      fullName: 'Patrick Nkurunziza',
      avatarUrl: 'https://i.pravatar.cc/150?img=68',
      campus: 'Kigali Campus',
      department: 'Electrical Engineering',
      yearOfStudy: 'Year 1',
      role: UserRole.student,
      isOnline: false,
      clubIds: ['clb_001'],
      eventIds: ['evt_003', 'evt_005'],
      friendIds: ['usr_001', 'usr_003'],
      postIds: ['pst_005'],
      metadata: {
        'createdAt': '2024-09-03T08:00:00Z',
        'updatedAt': '2024-11-10T14:20:00Z',
        'connects': 29,
        'bio': 'First year. Excited to build things.',
        'linkedIn': '',
        'isVerified': false,
        'lastSeen': '2024-11-18T22:00:00Z',
      },
    ),
    UserModel(
      id: 'usr_005',
      username: 'admin.system',
      email: 'admin@kigali.edu',
      password: 'Admin@SuperSecure99',
      fullName: 'System Administrator',
      avatarUrl: 'https://i.pravatar.cc/150?img=1',
      campus: 'All Campuses',
      department: 'Administration',
      yearOfStudy: 'N/A',
      role: UserRole.admin,
      isOnline: true,
      clubIds: [],
      eventIds: [],
      friendIds: [],
      postIds: ['pst_006'],
      metadata: {
        'createdAt': '2020-01-01T00:00:00Z',
        'updatedAt': '2024-11-20T00:00:00Z',
        'connects': 0,
        'bio': 'Platform administrator.',
        'linkedIn': '',
        'isVerified': true,
        'lastSeen': '2024-11-20T10:00:00Z',
      },
    ),
  ];

  // ── CLUBS ──────────────────────────────────

  static final List<ClubModel> clubs = [
    ClubModel(
      id: 'clb_001',
      name: 'Tech Innovators',
      description: 'A club for students passionate about technology, coding, and innovation.',
      leaderId: 'usr_002',
      category: ClubCategory.tech,
      campus: 'Kigali Campus',
      logoUrl: 'https://ui-avatars.com/api/?name=Tech+Innovators&background=4648D4&color=fff&size=150&bold=true&rounded=true',
      memberIds: ['usr_001', 'usr_002', 'usr_004'],
      eventIds: ['evt_001', 'evt_003'],
      isVerified: true,
      metadata: {
        'createdAt': '2021-03-10T00:00:00Z',
        'updatedAt': '2024-10-01T00:00:00Z',
        'totalEvents': 23,
        'tags': ['coding', 'AI', 'hackathon'],
        'socialLinks': {
          'instagram': '@techinnovators_kigali',
          'twitter': '@techinno_kig',
        },
      },
    ),
    ClubModel(
      id: 'clb_002',
      name: 'Entrepreneurs Hub',
      description: 'Building tomorrow\'s business leaders through mentorship and networking.',
      leaderId: 'usr_002',
      category: ClubCategory.business,
      campus: 'Kigali Campus',
      logoUrl: 'https://ui-avatars.com/api/?name=Entrepreneurs+Hub&background=B90538&color=fff&size=150&bold=true&rounded=true',
      memberIds: ['usr_002', 'usr_005'],
      eventIds: ['evt_002'],
      isVerified: true,
      metadata: {
        'createdAt': '2022-01-20T00:00:00Z',
        'updatedAt': '2024-09-15T00:00:00Z',
        'totalEvents': 15,
        'tags': ['startup', 'pitch', 'business'],
        'socialLinks': {
          'instagram': '@entreprhub',
          'twitter': '',
        },
      },
    ),
    ClubModel(
      id: 'clb_003',
      name: 'Health & Wellness Circle',
      description: 'Promoting mental and physical wellness across all campuses.',
      leaderId: 'usr_003',
      category: ClubCategory.social,
      campus: 'Huye Campus',
      logoUrl: 'https://ui-avatars.com/api/?name=Health+Wellness&background=00885D&color=fff&size=150&bold=true&rounded=true',
      memberIds: ['usr_001', 'usr_003'],
      eventIds: ['evt_004', 'evt_005'],
      isVerified: false,
      metadata: {
        'createdAt': '2023-05-01T00:00:00Z',
        'updatedAt': '2024-08-10T00:00:00Z',
        'totalEvents': 8,
        'tags': ['wellness', 'mental health', 'fitness'],
        'socialLinks': {
          'instagram': '@hwcircle',
          'twitter': '',
        },
      },
    ),
  ];

  // ── EVENTS ─────────────────────────────────

  static final List<EventModel> events = [
    EventModel(
      id: 'evt_001',
      title: 'Rwanda Dev Summit 2024',
      description: 'Annual gathering of student developers. Talks, workshops, and networking.',
      organizerId: 'usr_002',
      clubId: 'clb_001',
      category: EventCategory.tech,
      location: 'Main Auditorium, Kigali Campus',
      campus: 'Kigali Campus',
      startDate: DateTime(2024, 12, 5, 9, 0),
      endDate: DateTime(2024, 12, 5, 17, 0),
      bannerUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?w=600&h=300&fit=crop',
      maxAttendees: 300,
      attendeeIds: ['usr_001', 'usr_002', 'usr_004'],
      isPublic: true,
      rsvpStatus: 'going',
      metadata: {
        'createdAt': '2024-10-01T00:00:00Z',
        'updatedAt': '2024-11-01T00:00:00Z',
        'tags': ['tech', 'dev', 'networking'],
        'isFeatured': true,
        'registrationDeadline': '2024-12-01T23:59:00Z',
        'ticketPrice': 0.0,
        'currency': 'RWF',
      },
    ),
    EventModel(
      id: 'evt_002',
      title: 'Startup Pitch Night',
      description: 'Present your startup idea to a panel of judges and investors.',
      organizerId: 'usr_002',
      clubId: 'clb_002',
      category: EventCategory.career,
      location: 'Innovation Hub, Block C',
      campus: 'Kigali Campus',
      startDate: DateTime(2024, 12, 12, 18, 0),
      endDate: DateTime(2024, 12, 12, 21, 0),
      bannerUrl: 'https://images.unsplash.com/photo-1559136555-9303baea8ebd?w=600&h=300&fit=crop',
      maxAttendees: 100,
      attendeeIds: ['usr_001', 'usr_003'],
      isPublic: true,
      rsvpStatus: 'interested',
      metadata: {
        'createdAt': '2024-10-15T00:00:00Z',
        'updatedAt': '2024-11-05T00:00:00Z',
        'tags': ['startup', 'pitch', 'investment'],
        'isFeatured': false,
        'registrationDeadline': '2024-12-10T23:59:00Z',
        'ticketPrice': 0.0,
        'currency': 'RWF',
      },
    ),
    EventModel(
      id: 'evt_003',
      title: 'Inter-Campus Hackathon',
      description: '48-hour hackathon open to all campuses. Theme: EdTech for Africa.',
      organizerId: 'usr_001',
      clubId: 'clb_001',
      category: EventCategory.academic,
      location: 'Computer Lab 2, Kigali Campus',
      campus: 'Kigali Campus',
      startDate: DateTime(2025, 1, 10, 8, 0),
      endDate: DateTime(2025, 1, 12, 8, 0),
      bannerUrl: 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=600&h=300&fit=crop',
      maxAttendees: 120,
      attendeeIds: ['usr_002', 'usr_004'],
      isPublic: true,
      rsvpStatus: 'going',
      metadata: {
        'createdAt': '2024-11-01T00:00:00Z',
        'updatedAt': '2024-11-18T00:00:00Z',
        'tags': ['hackathon', 'edtech', '48h'],
        'isFeatured': true,
        'registrationDeadline': '2025-01-05T23:59:00Z',
        'ticketPrice': 0.0,
        'currency': 'RWF',
      },
    ),
    EventModel(
      id: 'evt_004',
      title: 'Mental Health Awareness Week',
      description: 'A week of talks, workshops, and activities promoting student mental health.',
      organizerId: 'usr_003',
      clubId: 'clb_003',
      category: EventCategory.social,
      location: 'Campus Green, Huye',
      campus: 'Huye Campus',
      startDate: DateTime(2024, 11, 25, 9, 0),
      endDate: DateTime(2024, 11, 29, 17, 0),
      bannerUrl: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?w=600&h=300&fit=crop',
      maxAttendees: 500,
      attendeeIds: ['usr_003'],
      isPublic: true,
      rsvpStatus: 'interested',
      metadata: {
        'createdAt': '2024-10-20T00:00:00Z',
        'updatedAt': '2024-11-10T00:00:00Z',
        'tags': ['mental health', 'wellness', 'students'],
        'isFeatured': false,
        'registrationDeadline': '2024-11-24T23:59:00Z',
        'ticketPrice': 0.0,
        'currency': 'RWF',
      },
    ),
    EventModel(
      id: 'evt_005',
      title: 'End of Year Gala',
      description: 'Celebrate the academic year with music, awards, and food.',
      organizerId: 'usr_005',
      clubId: 'clb_003',
      category: EventCategory.cultural,
      location: 'Grand Hall, Kigali Campus',
      campus: 'Kigali Campus',
      startDate: DateTime(2024, 12, 20, 19, 0),
      endDate: DateTime(2024, 12, 20, 23, 59),
      bannerUrl: 'https://images.unsplash.com/photo-1492684223066-81342ee5ff30?w=600&h=300&fit=crop',
      maxAttendees: 600,
      attendeeIds: ['usr_001', 'usr_004'],
      isPublic: true,
      rsvpStatus: 'going',
      metadata: {
        'createdAt': '2024-09-01T00:00:00Z',
        'updatedAt': '2024-11-15T00:00:00Z',
        'tags': ['gala', 'awards', 'celebration'],
        'isFeatured': true,
        'registrationDeadline': '2024-12-18T23:59:00Z',
        'ticketPrice': 5000.0,
        'currency': 'RWF',
      },
    ),
  ];

  // ── POSTS ──────────────────────────────────

  static final List<PostModel> posts = [
    PostModel(
      id: 'pst_001',
      authorId: 'usr_001',
      content: 'Just finished building my first Flutter app! The journey was tough but worth it.',
      type: PostType.text,
      imageUrls: [],
      likeIds: ['usr_002', 'usr_003', 'usr_004'],
      comments: [
        CommentModel(
          id: 'cmt_001',
          authorId: 'usr_002',
          content: 'Congrats Aline! Would love to see a demo.',
          likeIds: ['usr_001'],
          createdAt: DateTime(2024, 11, 14, 10, 5),
          metadata: {'editedAt': null, 'isReported': false},
        ),
      ],
      clubId: 'clb_001',
      eventId: null,
      isPinned: false,
      createdAt: DateTime(2024, 11, 14, 9, 30),
      updatedAt: DateTime(2024, 11, 14, 9, 30),
      metadata: {
        'views': 142,
        'shares': 3,
        'isReported': false,
        'tags': ['flutter', 'development'],
      },
    ),
    PostModel(
      id: 'pst_002',
      authorId: 'usr_002',
      content: 'Excited to announce the Startup Pitch Night on Dec 12! Register now.',
      type: PostType.announcement,
      imageUrls: ['https://images.unsplash.com/photo-1556761175-4b46a572b786?w=600&h=400&fit=crop'],
      likeIds: ['usr_001', 'usr_005'],
      comments: [],
      clubId: 'clb_002',
      eventId: 'evt_002',
      isPinned: true,
      createdAt: DateTime(2024, 11, 10, 14, 0),
      updatedAt: DateTime(2024, 11, 10, 14, 0),
      metadata: {
        'views': 310,
        'shares': 12,
        'isReported': false,
        'tags': ['startup', 'event'],
      },
    ),
    PostModel(
      id: 'pst_003',
      authorId: 'usr_001',
      content: 'Campus life hits different in November. The weather, the vibe, everything.',
      type: PostType.image,
      imageUrls: [
        'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=600&h=400&fit=crop',
        'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?w=600&h=400&fit=crop',
      ],
      likeIds: ['usr_003', 'usr_004'],
      comments: [
        CommentModel(
          id: 'cmt_002',
          authorId: 'usr_003',
          content: 'Huye is even better trust me.',
          likeIds: [],
          createdAt: DateTime(2024, 11, 12, 17, 20),
          metadata: {'editedAt': null, 'isReported': false},
        ),
      ],
      clubId: null,
      eventId: null,
      isPinned: false,
      createdAt: DateTime(2024, 11, 12, 16, 45),
      updatedAt: DateTime(2024, 11, 12, 16, 45),
      metadata: {
        'views': 89,
        'shares': 1,
        'isReported': false,
        'tags': ['campuslife', 'kigali'],
      },
    ),
    PostModel(
      id: 'pst_004',
      authorId: 'usr_003',
      content: 'Remember: your mental health matters more than your GPA. Take care of yourselves.',
      type: PostType.text,
      imageUrls: [],
      likeIds: ['usr_001', 'usr_002', 'usr_004', 'usr_005'],
      comments: [],
      clubId: 'clb_003',
      eventId: 'evt_004',
      isPinned: false,
      createdAt: DateTime(2024, 11, 8, 12, 0),
      updatedAt: DateTime(2024, 11, 8, 12, 0),
      metadata: {
        'views': 504,
        'shares': 28,
        'isReported': false,
        'tags': ['mentalhealth', 'wellness'],
      },
    ),
    PostModel(
      id: 'pst_005',
      authorId: 'usr_004',
      content: 'First year student here. Any tips on surviving Engineering Year 1?',
      type: PostType.text,
      imageUrls: [],
      likeIds: ['usr_001'],
      comments: [
        CommentModel(
          id: 'cmt_003',
          authorId: 'usr_001',
          content: 'Join Tech Innovators! Best decision I made in Year 1.',
          likeIds: ['usr_004'],
          createdAt: DateTime(2024, 11, 5, 9, 10),
          metadata: {'editedAt': null, 'isReported': false},
        ),
      ],
      clubId: null,
      eventId: null,
      isPinned: false,
      createdAt: DateTime(2024, 11, 5, 9, 0),
      updatedAt: DateTime(2024, 11, 5, 9, 0),
      metadata: {
        'views': 67,
        'shares': 0,
        'isReported': false,
        'tags': ['newstudent', 'engineering'],
      },
    ),
    PostModel(
      id: 'pst_006',
      authorId: 'usr_005',
      content: 'System maintenance scheduled for Sunday 24 Nov, 2:00 AM – 4:00 AM. Plan accordingly.',
      type: PostType.announcement,
      imageUrls: [],
      likeIds: [],
      comments: [],
      clubId: null,
      eventId: null,
      isPinned: true,
      createdAt: DateTime(2024, 11, 20, 8, 0),
      updatedAt: DateTime(2024, 11, 20, 8, 0),
      metadata: {
        'views': 890,
        'shares': 0,
        'isReported': false,
        'tags': ['system', 'maintenance'],
      },
    ),
  ];

  // ── CHATS ──────────────────────────────────

  static final List<ChatThreadModel> chatThreads = [
    ChatThreadModel(
      id: 'thd_001',
      participantIds: ['usr_001', 'usr_002'],
      lastActivity: DateTime(2024, 11, 19, 20, 45),
      messages: [
        MessageModel(
          id: 'msg_001',
          senderId: 'usr_002',
          receiverId: 'usr_001',
          content: 'Hey Aline, are you coming to the pitch night?',
          status: MessageStatus.read,
          sentAt: DateTime(2024, 11, 19, 20, 30),
          isDeleted: false,
          metadata: {'isEdited': false, 'reactionEmoji': null},
        ),
        MessageModel(
          id: 'msg_002',
          senderId: 'usr_001',
          receiverId: 'usr_002',
          content: 'Yes definitely! Already registered.',
          status: MessageStatus.read,
          sentAt: DateTime(2024, 11, 19, 20, 35),
          isDeleted: false,
          metadata: {'isEdited': false, 'reactionEmoji': '👍'},
        ),
        MessageModel(
          id: 'msg_003',
          senderId: 'usr_002',
          receiverId: 'usr_001',
          content: 'Amazing! See you there.',
          status: MessageStatus.delivered,
          sentAt: DateTime(2024, 11, 19, 20, 45),
          isDeleted: false,
          metadata: {'isEdited': false, 'reactionEmoji': null},
        ),
      ],
      metadata: {
        'createdAt': '2024-10-01T00:00:00Z',
        'isGroupChat': false,
        'isMuted': false,
      },
    ),
    ChatThreadModel(
      id: 'thd_002',
      participantIds: ['usr_001', 'usr_003'],
      lastActivity: DateTime(2024, 11, 18, 15, 0),
      messages: [
        MessageModel(
          id: 'msg_004',
          senderId: 'usr_003',
          receiverId: 'usr_001',
          content: 'Did you see my post about mental health week?',
          status: MessageStatus.read,
          sentAt: DateTime(2024, 11, 18, 14, 50),
          isDeleted: false,
          metadata: {'isEdited': false, 'reactionEmoji': null},
        ),
        MessageModel(
          id: 'msg_005',
          senderId: 'usr_001',
          receiverId: 'usr_003',
          content: 'Yes! Shared it with my whole year. So important.',
          status: MessageStatus.read,
          sentAt: DateTime(2024, 11, 18, 15, 0),
          isDeleted: false,
          metadata: {'isEdited': false, 'reactionEmoji': '❤️'},
        ),
      ],
      metadata: {
        'createdAt': '2024-09-15T00:00:00Z',
        'isGroupChat': false,
        'isMuted': false,
      },
    ),
  ];

  // ── NOTIFICATIONS ──────────────────────────

  static final List<NotificationModel> notifications = [
    NotificationModel(
      id: 'ntf_001',
      userId: 'usr_001',
      title: 'Eric liked your post',
      body: '"Just finished building my first Flutter app!"',
      type: 'like',
      isRead: false,
      createdAt: DateTime(2024, 11, 14, 10, 0),
      metadata: {'actorId': 'usr_002', 'targetId': 'pst_001', 'targetType': 'post'},
    ),
    NotificationModel(
      id: 'ntf_002',
      userId: 'usr_001',
      title: 'New event: Rwanda Dev Summit 2024',
      body: 'Tech Innovators club posted a new event you might like.',
      type: 'event',
      isRead: true,
      createdAt: DateTime(2024, 11, 10, 9, 0),
      metadata: {'actorId': 'clb_001', 'targetId': 'evt_001', 'targetType': 'event'},
    ),
    NotificationModel(
      id: 'ntf_003',
      userId: 'usr_001',
      title: 'Patrick sent you a connect request',
      body: 'Patrick Nkurunziza wants to connect with you.',
      type: 'connect_request',
      isRead: false,
      createdAt: DateTime(2024, 11, 19, 8, 30),
      metadata: {'actorId': 'usr_004', 'targetId': 'usr_001', 'targetType': 'user'},
    ),
    NotificationModel(
      id: 'ntf_004',
      userId: 'usr_001',
      title: 'Reminder: Startup Pitch Night tomorrow',
      body: 'The event starts at 6:00 PM at Innovation Hub.',
      type: 'reminder',
      isRead: false,
      createdAt: DateTime(2024, 12, 11, 9, 0),
      metadata: {'actorId': 'clb_002', 'targetId': 'evt_002', 'targetType': 'event'},
    ),
  ];

  // ── LOOKUP HELPERS ─────────────────────────

  static UserModel? getUserById(String id) =>
      users.cast<UserModel?>().firstWhere((u) => u?.id == id, orElse: () => null);

  static UserModel? getUserByEmail(String email) =>
      users.cast<UserModel?>().firstWhere((u) => u?.email == email, orElse: () => null);

  static UserModel? login(String email, String password) =>
      users.cast<UserModel?>().firstWhere(
        (u) => u?.email == email && u?.password == password,
        orElse: () => null,
      );

  static EventModel? getEventById(String id) =>
      events.cast<EventModel?>().firstWhere((e) => e?.id == id, orElse: () => null);

  static ClubModel? getClubById(String id) =>
      clubs.cast<ClubModel?>().firstWhere((c) => c?.id == id, orElse: () => null);

  static List<PostModel> getPostsByUser(String userId) =>
      posts.where((p) => p.authorId == userId).toList();

  static List<EventModel> getEventsByUser(String userId) =>
      events.where((e) => e.attendeeIds.contains(userId)).toList();

  static List<NotificationModel> getNotificationsForUser(String userId) =>
      notifications.where((n) => n.userId == userId).toList();

  static ChatThreadModel? getThreadByParticipants(String uid1, String uid2) =>
      chatThreads.cast<ChatThreadModel?>().firstWhere(
        (t) => t!.participantIds.contains(uid1) && t.participantIds.contains(uid2),
        orElse: () => null,
      );
}
