class ModelCalls {
  String? createdAt;
  String? updatedAt;
  String? uuid;
  Client? client;
  LastMessage? lastMessage;

  ModelCalls(
      {this.createdAt,
      this.updatedAt,
      this.uuid,
      this.client,
      this.lastMessage});

  ModelCalls.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uuid = json['uuid'];
    client =
        json['client'] != null ? new Client.fromJson(json['client']) : null;
    lastMessage = json['last_message'] != null
        ? new LastMessage.fromJson(json['last_message'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['uuid'] = this.uuid;
    if (this.client != null) {
      data['client'] = this.client?.toJson();
    }
    if (this.lastMessage != null) {
      data['last_message'] = this.lastMessage?.toJson();
    }
    return data;
  }
}

class Client {
  String? uuid;
  String? createdAt;
  String? updatedAt;
  String? name;
  String? phone;

  Client({this.uuid, this.createdAt, this.updatedAt, this.name, this.phone});

  Client.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    phone = json['phone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['phone'] = this.phone;
    return data;
  }
}

class LastMessage {
  String? createdAt;
  String? updatedAt;
  String? uuid;
  String? message;
  String? file;
  String? type;
  String? status;
  String? helpDesk;

  LastMessage(
      {this.createdAt,
      this.updatedAt,
      this.uuid,
      this.message,
      this.file,
      this.type,
      this.status,
      this.helpDesk});

  LastMessage.fromJson(Map<String, dynamic> json) {
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    uuid = json['uuid'];
    message = json['message'];
    file = json['file'];
    type = json['type'];
    status = json['status'];
    helpDesk = json['help_desk'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['uuid'] = this.uuid;
    data['message'] = this.message;
    data['file'] = this.file;
    data['type'] = this.type;
    data['status'] = this.status;
    data['help_desk'] = this.helpDesk;
    return data;
  }
}
