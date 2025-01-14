class RoomState {
  final bool isLoading;
  final String? error;
  final bool isDeleting;
  final String? deletingRoomId;

  RoomState({
    this.isLoading = false,
    this.error,
    this.isDeleting = false,
    this.deletingRoomId,
  });

  RoomState copyWith({
    bool? isLoading,
    String? error,
    bool? isDeleting,
    String? deletingRoomId,
  }) {
    return RoomState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isDeleting: isDeleting ?? this.isDeleting,
      deletingRoomId: deletingRoomId ?? this.deletingRoomId,
    );
  }
}
