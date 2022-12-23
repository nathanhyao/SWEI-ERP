class Request {
  // Shifts and request objects should track sender and recipient emails and names for identification
  //
  // When users update their emails, shifts and request objects should update those emails accordingly
  //        Updating names in those objects is less important
  //
  // This ensures shifts and requests objects are still tied to their correct users after profile changes

  String senderName = ''; // name of user making the request
  String senderEmail = ''; // name of user making the request
  String recipientName = ''; // name of user receiving the request
  String recipientEmail = ''; // name of user receiving the request

  String shiftStartTime = '';
  String shiftEndTime = '';

  /*
  // String time format TBD
  String senderShiftStartTime = ''; // Start time of request sender's shift
  String senderShiftEndTime = ''; // End time of request sender's shift

  // String time format TBD
  String recipientShiftStartTime = ''; // Start time of recipient's shift
  String recipientShiftEndTime = ''; // End time of recipient's shift*/

  Request(
    this.senderName,
    this.recipientName,
    this.shiftStartTime,
    this.shiftEndTime,

    /*
    this.senderShiftStartTime,
    this.senderShiftEndTime,
    this.recipientShiftStartTime,
    this.recipientShiftEndTime,*/
  );

  Request.fromJson(Map<String, dynamic> json) {
    senderName = json['sender_name'];
    senderEmail = json['sender_email'];
    recipientName = json['recipient_name'];
    recipientEmail = json['recipient_email'];
    shiftStartTime = json['shift_start_time'];
    shiftEndTime = json['shift_end_time'];

    /*
    // Details of shift event to be given (from sender's perspective)
    senderShiftStartTime = json['sender_shift_start_time'];
    senderShiftEndTime = json['sender_shift_end_time'];

    // Details of shift event to be received (from sender's perspective)
    recipientShiftStartTime = json['recipient_shift_start_time'];
    recipientShiftEndTime = json['recipient_shift_end_time'];*/
  }
}
