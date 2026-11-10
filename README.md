# MD_Midterm_Santiago_-3.8-
The Community Learning Center Management System is a Dart console app built to streamline hub operations. It allows administrators to register educational resources and participants, process transactions with automated membership discounts, and maintain structured records using robust object-oriented programming principles.


1. **Record Registration & Management**
   - Register Learning Resources (Books, Equipment, Digital Media) with assigned rental fees.
   - Register Community Participants under different membership Tiers (Regular, Student, Senior).
2. **Transaction Processing & Discount Calculations**
   - Checkout resource items to registered participants.
   - Automatically calculate discounted rates based on membership type (20% for Students, 50% for Seniors) using operators.
3. **OOP Architecture & Design**
   - **Encapsulation:** Private properties (`_id`, `_titleOrName`, `_isAvailable`) with controlled getter methods.
   - **Inheritance & Polymorphism:** Subclasses (`LearningResource`, `Participant`) inheriting from an abstract base class (`CenterRecord`) and providing specialized implementations of `getDetails()`.
   - **Mixins:** `Printable` mixin used for consistent logging and timestamp formatting.
4. **Data Structures**
   - Internal storage managed via `List<CenterRecord>` for sequential output and `Map<String, CenterRecord>` for $O(1)$ fast ID lookup.
5. **Input Handling & Robust Error Prevention**
   - Interactive loop with menu selection.
   - Type validation for numerical inputs and non-empty string checks.
   - Graceful try-catch exception handling prevents unexpected terminations.

---

## Sample Test Scenarios

### Scenario 1: Standard Input & Record Registration (Valid Flow)
1. Select Option `1` to add a Learning Resource:
   - **ID:** `RES-01`
   - **Title:** `Dart Programming Fundamentals`
   - **Type:** `Book`
   - **Fee:** `10.00`
2. Select Option `2` to add a Participant:
   - **ID:** `PAR-01`
   - **Name:** `Alice Smith`
   - **Email:** `alice@example.com`
   - **Membership:** `Student`
3. **Result:** Records are stored successfully, and success feedback is printed.

---

### Scenario 2: Processing Transaction with Discount Calculation (Valid Flow)
1. Select Option `3` (Borrow Resource):
   - **Participant ID:** `PAR-01`
   - **Resource ID:** `RES-01`
2. **Result:** The system locates both records in the lookup Map, applies the 20% Student discount to the base fee (\$10.00 $\rightarrow$ \$8.00), marks the item status as `Checked Out`, and updates the participant's borrowed item counter.

---

### Scenario 3: Error Handling & Invalid Input Coverage (Error Flow)
1. **Invalid Menu Choice:** Enter `9` at the main menu.
   - *Expected Behavior:* System prints an error message without crashing and prompts the menu again.
2. **Duplicate Primary Keys:** Attempt to register a new participant with ID `PAR-01`.
   - *Expected Behavior:* System warns that the ID already exists and returns to the menu.
3. **Non-Numeric Fee Input:** Enter `abc` when prompted for the rental fee.
   - *Expected Behavior:* Input handler captures the format exception and reprompts for input.
4. **Attempting to Borrow Unavailable Item:** Attempt to borrow `RES-01` again after it has been checked out.
   - *Expected Behavior:* System displays an error stating the item is currently checked out.

---

## Instructions for Running the Program

### Prerequisites
- Install [Dart SDK](https://dart.dev/get-dart) (v2.18 or higher recommended), OR access [DartPad Console](https://dartpad.dev/?null_safety=true).

### Execution Steps
1. Clone this repository:
   ```bash
   git clone [https://github.com/](https://github.com/)[your-username]/MD_Midterm_Santiago_[3.8].git
   cd MD_Midterm_[Surname]_[Section]
