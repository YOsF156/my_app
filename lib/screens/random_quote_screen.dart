import 'package:flutter/material.dart';
import 'dart:math';

class RandomQuoteScreen extends StatelessWidget {
  final List<Map<String, String>> quotes = [
    {
      'quote': 'A ruffled mind makes a restless pillow.',
      'author': 'Charlotte Bronte'
    },
    {
      'quote':
          'A good laugh and a long sleep are the best cures in the doctor’s book.',
      'author': 'Irish Proverb'
    },
    {'quote': 'Sleep is the best meditation.', 'author': 'Dalai Lama'},
    {
      'quote': 'Man should forget his anger before he lies down to sleep.',
      'author': 'Mahatma Gandhi'
    },
    {
      'quote':
          'Happiness consists of getting enough sleep. Just that, nothing more.',
      'author': 'Robert A. Heinlein'
    },
    {
      'quote': 'Your future depends on your dreams, so go to sleep.',
      'author': 'Mesut Barazany'
    },
    {
      'quote': 'Sleep doesn’t help if it’s your soul that’s tired.',
      'author': 'Unknown'
    },
    {
      'quote': 'The nicest thing for me is sleep, then at least I can dream.',
      'author': 'Marilyn Monroe'
    },
    {'quote': 'Fatigue is the best pillow.', 'author': 'Benjamin Franklin'},
    {
      'quote': 'A well-spent day brings happy sleep.',
      'author': 'Leonardo da Vinci'
    },
    {
      'quote':
          'The amount of sleep required by the average person is five minutes more.',
      'author': 'Wilson Mizner'
    },
    {
      'quote':
          'Dreaming permits each and every one of us to be quietly and safely insane every night of our lives.',
      'author': 'William Dement'
    },
    {
      'quote': 'Sleep is the best reset button for the mind and body.',
      'author': 'Unknown'
    },
    {
      'quote':
          'There is a time for many words, and there is also a time for sleep.',
      'author': 'Homer'
    },
    {
      'quote': 'Let her sleep, for when she wakes, she will shake the world.',
      'author': 'Napoleon Bonaparte'
    },
    {
      'quote': 'Sleep is the fuel that powers your best self.',
      'author': 'Unknown'
    },
    {
      'quote': 'No day is so bad it can’t be fixed with a nap.',
      'author': 'Carrie Snow'
    },
    {'quote': 'A well-rested mind is a powerful mind.', 'author': 'Unknown'},
    {
      'quote':
          'Sleeping is no mean art: for its sake, one must stay awake all day.',
      'author': 'Friedrich Nietzsche'
    },
    {
      'quote': 'You can’t cheat sleep and expect to win in life.',
      'author': 'Unknown'
    },
    {'quote': 'Sleep is the silent healer.', 'author': 'Unknown'},
    {
      'quote':
          'Most people have no idea how good their body is designed to feel—until they get proper sleep.',
      'author': 'Unknown'
    },
    {
      'quote': 'The worst thing in the world is to try to sleep and not to.',
      'author': 'F. Scott Fitzgerald'
    },
    {
      'quote':
          'The best bridge between despair and hope is a good night’s sleep.',
      'author': 'E. Joseph Cossman'
    },
    {
      'quote':
          'Every closed eye is not sleeping, and every open eye is not seeing.',
      'author': 'Bill Cosby'
    },
    {
      'quote':
          'We are such stuff as dreams are made on, and our little life is rounded with a sleep.',
      'author': 'William Shakespeare'
    },
    {
      'quote': 'Don’t give up on your dreams, keep sleeping!',
      'author': 'Unknown'
    },
    {
      'quote':
          'Sleep is the foundation of both mental and physical resilience.',
      'author': 'Unknown'
    },
    {
      'quote': 'Without enough sleep, we all become tall two-year-olds.',
      'author': 'JoJo Jensen'
    },
    {
      'quote': 'Invest in your sleep; it pays back in energy, focus, and joy.',
      'author': 'Unknown'
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Generate a random index for the quote
    final random = Random();
    final quoteIndex = random.nextInt(quotes.length);
    final quote = quotes[quoteIndex];

    // Get the isFirstSession argument from the route
    final isFirstSession =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text('Random Quote'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('SleepReset Quotes'),
              SizedBox(height: 20),
              Text(
                '"${quote['quote']}"',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                '${quote['author']}',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Navigate based on whether it's the first session
                  if (isFirstSession) {
                    Navigator.pushReplacementNamed(
                        context, '/session-instructions');
                  } else {
                    Navigator.pushReplacementNamed(context, '/home');
                  }
                },
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
