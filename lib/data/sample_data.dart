import '../models/book.dart';

abstract final class SampleData {
  static const profileAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuCM9XB1RvJE_aiXw-iSLEgwkPqhwch5i5gRPCNzBh93M2p5J2oMUFycAxq0ZniGxAEQSLeGSst4FNAQF3AUvO1jg0Cv114fcm1Fy5y7x0SRdgiQr_uECfQ9B0ITOjlpNjIU4WoVzwJqAGVc-ZiPQNP3kfwaNUmZXZyVnPP6zoNsoK0NCI6oJUghNxpw1bgU4wnhSKrieTriRDLvELuOMIFvcRUu-gYSKpKdmXq4PnwhSuF_9zTrxBlXB1t6a8kRVNTqf4d2ddr377U';

  static const statsAvatar =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuAkT5t9vgEod6HirlHDTrbdADeg1x3fTmmjVpt1e-vzB1OT9UI5hGVICjjBSBGrIaqmx56lO_Acj3E22wOkdeNEgAXebDPZ_iH75PFHEiIMO_JY4Su62RqrQ8mTtE1_B7sYZXZGvPVsYe7eYKoYUD6aNMGjhSvgehbaufJxBXJVx_ziiqPTYqHz2RFfOp1qar-mUePnCuQ3WIrtaue4f3Lqa8Cvrd-HD8Rdw76keoX_qHC2GLCgPHpwjVUQfV_G22uhe5WRm6yabxw';

  static const currentReading = ReadingBook(
    title: 'The Secret History',
    author: 'Donna Tartt',
    coverUrl:
        'https://lh3.googleusercontent.com/aida-public/AB6AXuAPUrDuBctfNkx2uj2BeE8CCN-QTWOXGDw8BV0Dla7MGnKamBh0MF4FRrTLQG-CmVo8uyucFBHrDpBVETlRsYN0QE2w7toFzJG9eZ_v-JWc3jd4d8pcQoAviuH84ddxtsTIgJeuwQXed1ZQpQb5tFcXXRmKVy2xJvapsqaNhlWZMOfMi-vCiszp-tNBxKBjiUeAYqq1BBaMoOCcWpNOVhXbcV9Jj_yoZLodLo4V8mYN4H3VaoQW1t6GzV0duHmBALtL5GEqmHSXc2U',
    progress: 0.64,
    currentPage: 328,
    totalPages: 512,
  );

  static const recommendations = [
    Book(
      title: 'Normal People',
      author: 'Sally Rooney',
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCavNs8v4RcSdbBFmPlYoAbCg5IVknCXRBuz6etvE5GF9bh9iA8nvgFrZ0LrbaDMz2Lg6twOHMuf_o0qExciFHlcsfV97lrL5MZVsYj9x7JrpTO_CFOCyDqikZWTQzgD7qcdwvCAHY5TG4aFi-JHzcD1mGEUhmmuwLYzqOh_d_3RD2s2w4jsAZLMc505dSkWkP4hZzg1izRGyoTK0z2BZjZs63GrezUuLmZF54mcicAe0M7aX_dXb4Vjixhzqxp4Qv8X90Q_Bf9XMk',
    ),
    Book(
      title: 'Circe',
      author: 'Madeline Miller',
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCFNWeSFs93b3eFOIXxT8PCXUHHWBkbA0gM00mHUi45N6MaUJKYBSRCtitzbXISnMf-9JUYiyaR5_KNyaW4BbHL_HcBKYfgIfv_hbHpIZxv2FZmxwvafN-ZCFGC3o6Wff9jkSmM6iYVlTgYQtTbM4hzwES3f2rgJRLefl7DwiEdfVJavEFyHHA4bQZnbNruEjGOLdSLjhxfHAC9gA5c3MtD0PB6vdmh3oRp0bTVyEXnTv1_py0KEdH2euR3qn2doY-Sxx7wnipmHnM',
    ),
    Book(
      title: 'Klara and the Sun',
      author: 'Kazuo Ishiguro',
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCwYvdsgYYU0hzvfJs7M1PZqL4afNyqXYyex_wNHsvGUMvkiND_HsFktF5XZFOrq83MrgGv0WVb3vx34ltu2Pydr7wsWE7-rrUfmb3Px5TSCDIhXOXLco6_xrZNUV0zAi9BXpF3lAXdzUCOpeDG9vJpzS2rQukCWgEY6MnOypnqpcDx7f1SY-CsZPO-CtpM6XW6zzNd-srp4GSOSIXJLbJIc9a48glL1wQ5sw5SAxkaQtYyShvXaYGd3kGWNv4zdoD5xH7XxmkjLZ8',
    ),
  ];

  static const discoverStack = [
    Book(
      title: 'The Midnight Library',
      author: 'Matt Haig',
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCXezartHqEaP6-LGlkZtL66ApiUpxs3PgVy_dp2j8c6la4XOs2pCaVLdphhyr0HcXz48fGOgmQsT4dKbSmL3Rr55e23q8ZYi8-NpYS6Wwbqe5pBd0tZcGULyE899WBF8q3s0PjQPwpRY6ZUnUnlbnT7XeouuRChK9_Hu3Mdx0e7Pc0MgRAVFNOFSyM3LJ7GOj4z1niXRHBQtb7WN3DIobPaiX50BxjCpNmpX1CQ6fJzPqQJGnD8QQTz5HBkQ9zr5is2y_-oICaSy8',
      rating: 4.8,
      genres: ['Historical Fiction', 'Mystery'],
    ),
    Book(
      title: 'Project Hail Mary',
      author: 'Andy Weir',
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBMuvoWzSCd3dnImjvA3CD1fTlgLC3Iz27ggBNBICazQY6VEbkYNDwMq5IIz87wBoGL31asTrcVJgn2lDLE4MfFW-H9YPY0P6soA2SlhfZMVJxDRVQghmAVN6DgXXxaP4tmEddaNzD1iVYI7I4AjbQlIZS3x8EikmTgzTY2MDtb86ReFdfuNclBNw48SXFXJEcIqnTxnYtcAmLolddFTFbF3JeEIjesn-ohKVB6zpvTcIFdtrCcNNIZecSo7phBauGMyo-rY2emNA0',
      rating: 4.9,
      genres: ['Sci-Fi', 'Adventure'],
    ),
    Book(
      title: 'The Seven Husbands of Evelyn Hugo',
      author: 'Taylor Jenkins Reid',
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAD1aFYqFBUywaIOCHz402YKYOfXACEtuQ-P_Gwe5hDQrIkm2-h3YYz9enDNcHlIMMVOEGY64p3XiK4OW73WsDGq42My53WMXwJs9SmLbvviPCSoutnViq46rKJmdb5s_PGviHkisVzO74i3cJST5EUkY11S4ONPc2i8SQlUZo90wYYldbWWamxGCgYFROgbW58OwsjDSjrMz0725R2M1qR-hPrsTwDg2ZXwIZ0_N1gOHF_uI1BltLMmTGoJ43KzAb5Rto-qfn0nrI',
      rating: 4.7,
      genres: ['Historical Fiction', 'Drama'],
    ),
  ];

  static const recentlyFinished = [
    Book(
      title: 'Stellar Echoes',
      author: 'A. K. Sterling',
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBMuvoWzSCd3dnImjvA3CD1fTlgLC3Iz27ggBNBICazQY6VEbkYNDwMq5IIz87wBoGL31asTrcVJgn2lDLE4MfFW-H9YPY0P6soA2SlhfZMVJxDRVQghmAVN6DgXXxaP4tmEddaNzD1iVYI7I4AjbQlIZS3x8EikmTgzTY2MDtb86ReFdfuNclBNw48SXFXJEcIqnTxnYtcAmLolddFTFbF3JeEIjesn-ohKVB6zpvTcIFdtrCcNNIZecSo7phBauGMyo-rY2emNA0',
    ),
    Book(
      title: 'The Quiet Mind',
      author: 'Elena Russo',
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCNw4X-xE-TEW58ZnjumdGr5hJQxkz6P90-f2pEoTJhl3VBaGBA0CcYd034yAEuxxJPJ0mP9QxpaZidxgisjqlRfpRs2HhYQaplb4Sq4skiwgjkCaUFp7BGjgzTVD9qdhJ1ch_EU02nwvEo95eadLy_0C-y4FEHWUQa-l8S3xp861S4d_RL6WyUJtwkicyZ6X8R1eaWDjUkNmrB07d8Ymjm0q7cQNAgdBst1slvvVQYp4fXUXGaA0Tad1-TEv8ZrkLjabqr3hZVs2M',
    ),
    Book(
      title: 'Verona Dreams',
      author: 'Julian Thorne',
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAD1aFYqFBUywaIOCHz402YKYOfXACEtuQ-P_Gwe5hDQrIkm2-h3YYz9enDNcHlIMMVOEGY64p3XiK4OW73WsDGq42My53WMXwJs9SmLbvviPCSoutnViq46rKJmdb5s_PGviHkisVzO74i3cJST5EUkY11S4ONPc2i8SQlUZo90wYYldbWWamxGCgYFROgbW58OwsjDSjrMz0725R2M1qR-hPrsTwDg2ZXwIZ0_N1gOHF_uI1BltLMmTGoJ43KzAb5Rto-qfn0nrI',
    ),
    Book(
      title: 'Beacon of Ages',
      author: 'Dr. Silas Vance',
      coverUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB2aYOm8gi2Zzg7-wxYBf2Gnedj-3pwEDc_D9viJWxmrYfThzZJRnNWTvgW5rd15kk62or43VVyuqmvfuqOhIFwf7oNZd0Jp_7LPMrYQvMx7_XtGMRhA4o9kYsRjVe454Yn9c-jdhn3lM-RwNZdLqnNOJH3sMTAFcqf4plOUyBIie31gw3jmrHSoFUID29J63DoFzEsl_eb3AFUHo2Si9ksL_g2KqZ3dc-6RxQR_aGY5_YldARL0ZxzYT0wWw__VjiFH8vkzu89I7k',
    ),
  ];

  static const communityPosts = [
    CommunityPost(
      author: 'Lia Readmore',
      handle: 'Lia Readmore',
      title: "Why we can't stop talking about slow-burn thrillers.",
      excerpt:
          'The architecture of suspense has changed. In this week\'s review, I delve into why the most gripping narratives are the ones that let the silence do the talking...',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBysGWVFUK7ojqjVq4vuLqFFqaCKOshNMG55p9vHEcciSPeCS8LylTYHINsL308gDMdJordFjf2L8WuO4WCja8B1Rezbj-cOlZpT4-82HwukzkSweLJYqBtKtkn5CTMko4jpnIeo6Iw8OGhyP8-L7nN-eNsxVBziK45ssIT3cHfrLHOfVERuZk7xdLPzcAK9YNVKafjURoPdPbWG1oS7MHIj44HfQ8Opg2KSVqWa9p2qUWNmtyqsHtaRsahQGgJagbhOvmWAaMBn1M',
      likes: 1200,
      comments: 84,
      timeAgo: '2h ago',
    ),
    CommunityPost(
      author: 'The Bookish Gent',
      handle: 'The Bookish Gent',
      title: 'Rainy Sunday: Finishing 3 books in one day.',
      excerpt:
          'Join me for a quiet afternoon of tea and literature. We tackle the new Murakami and revisit some classics by the window...',
      imageUrl:
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD7GBHL9CxJcjyO_Jk_9oSC6YSpY6d6Xe2lF40vnF7wwCStceFVZxgudBzbFN-8zSk4A3RmdmN1RXdg1ZgSSuaYHgw2M-Ntb65Xu9PpGAgHcwxNjUqXFIzHxnDCNyt7SnwaJ5AdVaJDtMYcXfBldT-dOoBBu0RJm1GjsGzyFkBwf8EmiST061HYk_cpaayuGJD-2pvhl4KYxyrIlDa6ykX6zSpHtENYuB-vo9Wl5fLmEniea2r3SxY_jLfp9PVfYZdZXQbwMmjngXw',
      likes: 3500,
      comments: 210,
      isVideo: true,
      timeAgo: '5h ago',
    ),
  ];

  static const genreBreakdown = [
    ('Sci-Fi & Fantasy', 0.40, BookwormGenreColor.primary),
    ('Classic Literature', 0.30, BookwormGenreColor.primaryDim),
    ('Historical Non-Fiction', 0.15, BookwormGenreColor.tertiary),
    ('Philosophy', 0.10, BookwormGenreColor.outline),
    ('Poetry', 0.05, BookwormGenreColor.outlineVariant),
  ];
}

enum BookwormGenreColor { primary, primaryDim, tertiary, outline, outlineVariant }
