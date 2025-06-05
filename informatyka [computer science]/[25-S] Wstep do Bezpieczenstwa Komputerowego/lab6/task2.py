import cv2
import torch


model = torch.hub.load('ultralytics/yolov5', 'yolov5s', pretrained=True)
model.conf = 0.5  # confidence threshold


cap = cv2.VideoCapture(0)

first_frame_saved = False
first_frame = None

while True:
    ret, frame = cap.read()
    if not ret:
        break


    results = model(frame)
    labels = results.names
    detections = results.pred[0]

    person_detected = False
    apple_detected = False

    for *box, conf, cls in detections:
        label = labels[int(cls)]
        if label == 'person':
            person_detected = True
        if label == 'apple':
            apple_detected = True


    if person_detected and not apple_detected:
        cv2.putText(frame, 'ALARM: Person Detected!', (20, 40), cv2.FONT_HERSHEY_SIMPLEX, 1, (0, 0, 255), 2)

    if person_detected and apple_detected:
        if not first_frame_saved:
            first_frame = frame.copy()
            first_frame_saved = True
            print("Zapisano pierwszą klatkę z osobą i jabłkiem")
        if first_frame is not None:
            cv2.imshow('First Frame with Person and Apple', first_frame)

    cv2.imshow('CCTV Stream', frame)

    if cv2.waitKey(1) & 0xFF == ord('q'):
        break

cap.release()
cv2.destroyAllWindows()
