mixin Printable {
  String formatTimestamp(DateTime dateTime) {
    return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";
  }

  void logAction(String action) {
    print("[LOG - ${formatTimestamp(DateTime.now())}]: $action");
  }
}

abstract class CenterRecord {
  final String _id;
  final String _titleOrName;
  final DateTime _registeredAt;

  CenterRecord(this._id, this._titleOrName) : _registeredAt = DateTime.now();

  String get id => _id;
  String get titleOrName => _titleOrName;
  DateTime get registeredAt => _registeredAt;

  String getDetails();
}

class LearningResource extends CenterRecord with Printable {
  final String _type;
  final double _baseFee;
  bool _isAvailable;

  LearningResource(
    String id,
    String title,
    this._type,
    this._baseFee, {
    bool isAvailable = true,
  })  : _isAvailable = isAvailable,
        super(id, title);

  String get type => _type;
  double get baseFee => _baseFee;
  bool get isAvailable => _isAvailable;

  void toggleAvailability() {
    _isAvailable = !_isAvailable;
  }

  @override
  String getDetails() {
    String status = _isAvailable ? "Available" : "Checked Out";
    return "[Resource ID: $id] $titleOrName ($type) - Fee: \$${_baseFee.toStringAsFixed(2)} | Status: $status | Added: ${formatTimestamp(registeredAt)}";
  }
}

class Participant extends CenterRecord with Printable {
  final String _email;
  final String _membershipType;
  int _borrowedCount = 0;

  Participant(
    String id,
    String name,
    this._email,
    this._membershipType,
  ) : super(id, name);

  String get email => _email;
  String get membershipType => _membershipType;
  int get borrowedCount => _borrowedCount;

  void incrementBorrowedCount() => _borrowedCount++;

  @override
  String getDetails() {
    return "[Participant ID: $id] $titleOrName ($membershipType) - Email: $_email | Borrowed Items: $_borrowedCount | Joined: ${formatTimestamp(registeredAt)}";
  }
}

class CommunityLearningCenter with Printable {
  // Collection storage
  final List<CenterRecord> _allRecords = [];
  final Map<String, CenterRecord> _recordLookup = {};

  void addRecord(CenterRecord record) {
    _allRecords.add(record);
    _recordLookup[record.id] = record;
    logAction("Added new record: ${record.titleOrName} (ID: ${record.id})");
  }

  CenterRecord? findRecord(String id) {
    return _recordLookup[id];
  }

  double calculateTransactionFee(LearningResource resource, Participant participant) {
    double fee = resource.baseFee;

    if (participant.membershipType.toLowerCase() == 'student') {
      fee *= 0.80;
    } else if (participant.membershipType.toLowerCase() == 'senior') {
      fee *= 0.50;
    }

    return fee;
  }

  bool processBorrowTransaction(String participantId, String resourceId) {
    CenterRecord? pRecord = _recordLookup[participantId];
    CenterRecord? rRecord = _recordLookup[resourceId];

    if (pRecord == null || pRecord is! Participant) {
      print("Error: Valid Participant ID not found.");
      return false;
    }

    if (rRecord == null || rRecord is! LearningResource) {
      print("Error: Valid Learning Resource ID not found.");
      return false;
    }

    Participant participant = pRecord;
    LearningResource resource = rRecord;

    if (!resource.isAvailable) {
      print("Error: Resource '${resource.titleOrName}' is currently checked out.");
      return false;
    }

    double finalFee = calculateTransactionFee(resource, participant);
    resource.toggleAvailability();
    participant.incrementBorrowedCount();

    print("\n--- Transaction Successful ---");
    print("Borrower: ${participant.titleOrName} (${participant.membershipType})");
    print("Item: ${resource.titleOrName}");
    print("Original Base Fee: \$${resource.baseFee.toStringAsFixed(2)}");
    print("Final Processed Fee: \$${finalFee.toStringAsFixed(2)}");
    print("-------------------------------\n");

    logAction("Processed borrow transaction for Resource ID $resourceId by Participant ID $participantId");
    return true;
  }

  void displayAllRecords() {
    if (_allRecords.isEmpty) {
      print("\nNo records registered in the system yet.");
      return;
    }

    print("\n================ SYSTEM RECORDS ================");
    for (var record in _allRecords) {
      print(record.getDetails());
    }
    print("================================================\n");
  }
}

String readNonEmptyString(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? input = stdin.readLineSync()?.trim();
    if (input != null && input.isNotEmpty) {
      return input;
    }
    print("Error: Input cannot be empty. Please try again.");
  }
}

double readPositiveDouble(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? input = stdin.readLineSync()?.trim();
    try {
      if (input != null) {
        double value = double.parse(input);
        if (value >= 0) return value;
      }
      print("Error: Please enter a non-negative number.");
    } catch (e) {
      print("Error: Invalid numerical input format.");
    }
  }
}

void main() {
  final CommunityLearningCenter center = CommunityLearningCenter();
  bool running = true;

  print("\n==================================================");
  print(" COMMUNITY LEARNING CENTER MANAGEMENT SYSTEM ");
  print("==================================================");

  while (running) {
    print("\nMAIN MENU:");
    print("1. Register Learning Resource");
    print("2. Register Participant");
    print("3. Borrow Resource (Process Transaction)");
    print("4. View All Records");
    print("5. Exit");

    stdout.write("Select an option (1-5): ");
    String? choice = stdin.readLineSync()?.trim();

    try {
      switch (choice) {
        case '1':
          print("\n--- Register Learning Resource ---");
          String id = readNonEmptyString("Enter Resource ID (e.g., RES-101): ");
          if (center.findRecord(id) != null) {
            print("Error: A record with ID '$id' already exists.");
            break;
          }
          String title = readNonEmptyString("Enter Resource Title: ");
          String type = readNonEmptyString("Enter Type (Book/Equipment/Digital): ");
          double fee = readPositiveDouble("Enter Base Rental/Borrow Fee (\$): ");

          LearningResource resource = LearningResource(id, title, type, fee);
          center.addRecord(resource);
          print("Success: Resource '$title' registered successfully!");
          break;

        case '2':
          print("\n--- Register Participant ---");
          String id = readNonEmptyString("Enter Participant ID (e.g., PAR-201): ");
          if (center.findRecord(id) != null) {
            print("Error: A record with ID '$id' already exists.");
            break;
          }
          String name = readNonEmptyString("Enter Participant Name: ");
          String email = readNonEmptyString("Enter Email Address: ");
          String membership = readNonEmptyString("Enter Membership (Regular/Student/Senior): ");

          Participant participant = Participant(id, name, email, membership);
          center.addRecord(participant);
          print("Success: Participant '$name' registered successfully!");
          break;

        case '3':
          print("\n--- Borrow Resource ---");
          String partId = readNonEmptyString("Enter Participant ID: ");
          String resId = readNonEmptyString("Enter Resource ID: ");
          center.processBorrowTransaction(partId, resId);
          break;

        case '4':
          center.displayAllRecords();
          break;

        case '5':
          running = false;
          print("\nExiting system. Thank you for using Community Learning Center Manager!");
          break;

        default:
          print("\nError: Choice '$choice' is invalid. Please select an option from 1 to 5.");
      }
    } catch (e, stackTrace) {
      print("\nAn unexpected error occurred: $e");
      print("Stack trace: $stackTrace");
    }
  }
}
