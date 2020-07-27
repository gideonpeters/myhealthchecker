import 'package:provider/provider.dart';

import 'contact_db.dart';

final providers = <SingleChildCloneableWidget>[
  ChangeNotifierProvider(create: (_) => ContactDB()),
];
