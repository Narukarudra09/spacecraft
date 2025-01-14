class KitchenState {
  final bool isLoading;
  final String? error;
  final bool isDeleting;
  final String? deletingRoomId;

  KitchenState({
    this.isLoading = false,
    this.error,
    this.isDeleting = false,
    this.deletingRoomId,
  });

  KitchenState copyWith({
    bool? isLoading,
    String? error,
    bool? isDeleting,
    String? deletingRoomId,
  }) {
    return KitchenState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isDeleting: isDeleting ?? this.isDeleting,
      deletingRoomId: deletingRoomId ?? this.deletingRoomId,
    );
  }
}
