import 'package:flutter/material.dart';

class BookingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient Header
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 32, horizontal: 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1976D2), Color(0xFFE3F0FF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Bookings', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          SizedBox(height: 24),
          // Room Bookings Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Room Bookings', style: Theme.of(context).textTheme.titleLarge),
          ),
          SizedBox(height: 12),
          Container(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                GestureDetector(
                  onTap: () => _showRoomBookingForm(context, 'Deluxe Room'),
                  child: _bookingCard('Deluxe Room', 'May 12-15', 'assets/rooms/deluxe-room-garden-view.jpg', '2,000,000đ'),
                ),
                GestureDetector(
                  onTap: () => _showRoomBookingForm(context, 'Family Suite'),
                  child: _bookingCard('Family Suite', 'May 16-18', 'assets/rooms/family-suite-beach-front.png', '3,500,000đ'),
                ),
                GestureDetector(
                  onTap: () => _showRoomBookingForm(context, 'Premium Bungalow'),
                  child: _bookingCard('Premium Bungalow', 'May 20-22', 'assets/rooms/premium-bungalow-beach-front.jpg', '4,200,000đ'),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          // Service Bookings Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Service Bookings', style: Theme.of(context).textTheme.titleLarge),
          ),
          SizedBox(height: 12),
          Container(
            height: 140,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                GestureDetector(
                  onTap: () => _showServiceBookingForm(context, 'Spa Package'),
                  child: _bookingCard('Spa Package', 'May 13, 2pm', 'assets/activites/spa.jpg', '800,000đ'),
                ),
                GestureDetector(
                  onTap: () => _showServiceBookingForm(context, 'Sport Rental'),
                  child: _bookingCard('Sport Rental', 'May 14, 10am', 'assets/activites/gym.jpg', '500,000đ'),
                ),
                GestureDetector(
                  onTap: () => _showServiceBookingForm(context, 'BBQ Dinner'),
                  child: _bookingCard('BBQ Dinner', 'May 14, 7pm', 'assets/rooms/family-suite-sea-view.png', '1,200,000đ'),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          // Local Events
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('Local Events', style: Theme.of(context).textTheme.titleLarge),
          ),
          SizedBox(height: 12),
          Container(
            height: 120,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              children: [
                _eventCard('Pool Party', 'May 14, 8pm', 'assets/rooms/premium-bungalow-beach-front.jpg'),
                _eventCard('Live Music', 'May 15, 7pm', 'assets/rooms/premium-bungalow-pool-view.jpg'),
                _eventCard('Kids Club', 'All Day', 'assets/rooms/family-suite-beach-front.png'),
              ],
            ),
          ),
          SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _bookingCard(String title, String date, String imageAsset, String price) {
    return Container(
      width: 180,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6)],
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.15), BlendMode.darken),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.05), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18, shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
            SizedBox(height: 6),
            Text(date, style: TextStyle(color: Colors.white, fontSize: 13, shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
            SizedBox(height: 6),
            Text(price, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Widget _eventCard(String title, String date, String imageAsset) {
    return Container(
      width: 140,
      margin: EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
        image: DecorationImage(
          image: AssetImage(imageAsset),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.15), BlendMode.darken),
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.05), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15, shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
            SizedBox(height: 4),
            Text(date, style: TextStyle(color: Colors.white, fontSize: 12, shadows: [Shadow(color: Colors.black26, blurRadius: 4)])),
          ],
        ),
      ),
    );
  }

  void _showRoomBookingForm(BuildContext context, String roomType) {
    DateTime? checkIn;
    DateTime? checkOut;
    int guests = 2;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Book $roomType'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) setState(() => checkIn = picked);
                  },
                  child: Text(checkIn == null ? 'Select Check-in Date' : 'Check-in: ${checkIn!.day}/${checkIn!.month}/${checkIn!.year}'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: checkIn ?? DateTime.now(),
                      firstDate: checkIn ?? DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 366)),
                    );
                    if (picked != null) setState(() => checkOut = picked);
                  },
                  child: Text(checkOut == null ? 'Select Check-out Date' : 'Check-out: ${checkOut!.day}/${checkOut!.month}/${checkOut!.year}'),
                ),
                Row(
                  children: [
                    Text('Guests:'),
                    SizedBox(width: 12),
                    DropdownButton<int>(
                      value: guests,
                      items: [1, 2, 3, 4, 5].map((g) => DropdownMenuItem(value: g, child: Text(' g'))).toList(),
                      onChanged: (v) => setState(() => guests = v!),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: (checkIn != null && checkOut != null)
                    ? () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Booking Confirmed'),
                            content: Text('Room: $roomType\nCheck-in: ${checkIn!.day}/${checkIn!.month}/${checkIn!.year}\nCheck-out: ${checkOut!.day}/${checkOut!.month}/${checkOut!.year}\nGuests: $guests'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    : null,
                child: Text('Book'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showServiceBookingForm(BuildContext context, String serviceType) {
    DateTime? date;
    TimeOfDay? time;
    String? option;
    List<String> options = serviceType == 'Spa Package'
        ? ['Facial', 'Massage', 'Full Spa']
        : serviceType == 'Sport Rental'
            ? ['Tennis', 'Badminton', 'Football']
            : ['Seafood', 'BBQ', 'Vegetarian'];
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Book $serviceType'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: option,
                  hint: Text('Select Option'),
                  items: options.map((o) => DropdownMenuItem(value: o, child: Text(o))).toList(),
                  onChanged: (v) => setState(() => option = v),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(Duration(days: 365)),
                    );
                    if (picked != null) setState(() => date = picked);
                  },
                  child: Text(date == null ? 'Select Date' : 'Date: ${date!.day}/${date!.month}/${date!.year}'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (picked != null) setState(() => time = picked);
                  },
                  child: Text(time == null ? 'Select Time' : 'Time: ${time!.format(context)}'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: (option != null && date != null && time != null)
                    ? () {
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Booking Confirmed'),
                            content: Text('Service: $serviceType\nOption: $option\nDate: ${date!.day}/${date!.month}/${date!.year}\nTime: ${time!.format(context)}'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      }
                    : null,
                child: Text('Book'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1976D2),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
} 