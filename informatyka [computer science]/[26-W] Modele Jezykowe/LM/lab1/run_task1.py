if __name__ == '__main__':
    print("Ładowanie modelu...")
    from chatbot_engine import DialogBot
    from sentence_probability import device
    bot = DialogBot()
    print(f"Gotowe! (urządzenie: {device}) Rozmawiasz z Markiem (Ctrl+C aby zakończyć).\n")

    try:
        while True:
            user_input = input("Ty: ").strip()

            if user_input:
                response = bot.generate_response(user_input)
                print(f"Marek: {response}")
    except (EOFError, KeyboardInterrupt):
        print("\nDo zobaczenia!")
