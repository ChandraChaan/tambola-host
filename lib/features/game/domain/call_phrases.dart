import 'settings.dart';

/// What to show and say for each called number.
abstract final class CallPhrases {
  /// The rhyming call for [number] (1–90), written for this app.
  static String rhyme(int number) => _rhymes[number - 1];

  /// English words for [number], for example "forty-two".
  static String englishWords(int number) {
    if (number < 20) return _ones[number];
    final tens = _tens[number ~/ 10];
    final ones = number % 10;
    return ones == 0 ? tens : '$tens-${_ones[ones]}';
  }

  /// Hindi words for [number] in Devanagari, for example "बयालीस".
  static String hindiWords(int number) => _hindi[number - 1];

  /// The full spoken call, such as "Four and two, forty-two."
  static String spoken(
    int number,
    VoiceLanguage language, {
    bool rhyme = false,
  }) {
    switch (language) {
      case VoiceLanguage.off:
        return '';
      case VoiceLanguage.english:
        final words = englishWords(number);
        final digits = number < 10
            ? 'Single number $words'
            : '${englishWords(number ~/ 10)} and ${englishWords(number % 10)}';
        return rhyme
            ? '${CallPhrases.rhyme(number)}. $digits, $words.'
            : '$digits, $words.';
      case VoiceLanguage.hindi:
        final words = hindiWords(number);
        if (number < 10) return 'अकेला $words.';
        final tens = hindiWords(number ~/ 10);
        final ones = number % 10 == 0 ? 'शून्य' : hindiWords(number % 10);
        return '$tens और $ones, $words.';
    }
  }

  static const List<String> _ones = [
    'zero', 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', //
    'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen',
    'sixteen', 'seventeen', 'eighteen', 'nineteen',
  ];

  static const List<String> _tens = [
    '', '', 'twenty', 'thirty', 'forty', 'fifty', 'sixty', 'seventy', //
    'eighty', 'ninety',
  ];

  static const List<String> _hindi = [
    'एक', 'दो', 'तीन', 'चार', 'पाँच', 'छह', 'सात', 'आठ', 'नौ', 'दस', //
    'ग्यारह', 'बारह', 'तेरह', 'चौदह', 'पंद्रह', 'सोलह', 'सत्रह', 'अठारह',
    'उन्नीस', 'बीस', 'इक्कीस', 'बाईस', 'तेईस', 'चौबीस', 'पच्चीस', 'छब्बीस',
    'सत्ताईस', 'अट्ठाईस', 'उनतीस', 'तीस', 'इकतीस', 'बत्तीस', 'तैंतीस',
    'चौंतीस', 'पैंतीस', 'छत्तीस', 'सैंतीस', 'अड़तीस', 'उनतालीस', 'चालीस',
    'इकतालीस', 'बयालीस', 'तैंतालीस', 'चवालीस', 'पैंतालीस', 'छियालीस',
    'सैंतालीस', 'अड़तालीस', 'उनचास', 'पचास', 'इक्यावन', 'बावन', 'तिरेपन',
    'चौवन', 'पचपन', 'छप्पन', 'सत्तावन', 'अट्ठावन', 'उनसठ', 'साठ', 'इकसठ',
    'बासठ', 'तिरेसठ', 'चौंसठ', 'पैंसठ', 'छियासठ', 'सड़सठ', 'अड़सठ',
    'उनहत्तर', 'सत्तर', 'इकहत्तर', 'बहत्तर', 'तिहत्तर', 'चौहत्तर',
    'पचहत्तर', 'छिहत्तर', 'सतहत्तर', 'अठहत्तर', 'उन्यासी', 'अस्सी',
    'इक्यासी', 'बयासी', 'तिरासी', 'चौरासी', 'पचासी', 'छियासी', 'सत्तासी',
    'अट्ठासी', 'नवासी', 'नब्बे',
  ];

  // Original rhyming calls, one per number. Feel free to send better ones!
  static const List<String> _rhymes = [
    'Number one, the fun has begun',
    'Me and you, number two',
    'Busy bee, number three',
    'Hit the dance floor, number four',
    'Give a high five, number five',
    'Magic tricks, number six',
    'Kites up to heaven, number seven',
    'Never be late, number eight',
    'Stand in line, number nine',
    'Count to ten, then again',
    'Full cricket team, number eleven',
    'One dozen, call your cousin',
    'Turning teen, thirteen',
    'Keep it clean, fourteen',
    'Quick and keen, fifteen',
    'Raw mango green, sixteen',
    'Shake the tambourine, seventeen',
    'Old enough to vote, eighteen',
    'Festival scene, nineteen',
    'Twenty, sweets aplenty',
    'Twenty-one, birthday fun',
    'Twenty-two, two in a queue',
    'Twenty-three, you and me',
    'Twenty-four, ask for more',
    'Twenty-five, bees in a hive',
    'Twenty-six, picnic mix',
    'Twenty-seven, rain from heaven',
    'Twenty-eight, clean your plate',
    'Twenty-nine, feeling fine',
    'Thirty, feeling sturdy',
    'Thirty-one, time to run',
    'Thirty-two, sky so blue',
    'Thirty-three, chai for me',
    'Thirty-four, mop the floor',
    'Thirty-five, take a drive',
    'Thirty-six, rangoli mix',
    'Thirty-seven, slice of heaven',
    'Thirty-eight, stay up late',
    'Thirty-nine, check the time',
    'Forty, life is sporty',
    'Forty-one, still having fun',
    'Forty-two, peek-a-boo',
    'Forty-three, climb the tree',
    'Forty-four, roar once more',
    'Forty-five, still alive',
    'Forty-six, building bricks',
    'Forty-seven, almost heaven',
    'Forty-eight, open the gate',
    'Forty-nine, train on time',
    'Half a ton, well done',
    'Fifty-one, tea and bun',
    'Fifty-two, cards for you',
    'Fifty-three, buzzing bee',
    'Fifty-four, knock some more',
    'Double five, bees arrive',
    'Fifty-six, mix and fix',
    'Fifty-seven, stars in heaven',
    'Fifty-eight, celebrate',
    'Fifty-nine, sunshine',
    'Sixty, one full hour',
    'Sixty-one, setting sun',
    'Sixty-two, morning dew',
    'Sixty-three, play with me',
    'Sixty-four, squares on the chessboard',
    'Sixty-five, retire and thrive',
    'Double six, cricket tricks',
    'Sixty-seven, chai at eleven',
    'Sixty-eight, pick a date',
    'Sixty-nine, upside down and fine',
    'Seventy, birthdays plenty',
    'Seventy-one, the sun has shone',
    'Seventy-two, shoes brand new',
    'Seventy-three, sail the sea',
    'Seventy-four, sandy shore',
    'Seventy-five, glad to be alive',
    'Seventy-six, pick and mix',
    'Double seven, sweets from heaven',
    'Seventy-eight, fill the plate',
    'Seventy-nine, one more time',
    'Eighty, nice and mighty',
    'Eighty-one, playing is fun',
    'Eighty-two, almost through',
    'Eighty-three, wait and see',
    'Eighty-four, open the store',
    'Eighty-five, keep it alive',
    'Eighty-six, last few tricks',
    'Eighty-seven, past eleven',
    'Double eight, two laddoos on a plate',
    'Eighty-nine, finish line',
    'Ninety, top of the board',
  ];
}
