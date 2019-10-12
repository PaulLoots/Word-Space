//
//  Words.swift
//  NiceOff
//
//  Created by Paul Loots on 2019/09/29.
//  Copyright © 2019 Paul Loots. All rights reserved.
//

import Foundation

//Basic Words

let nouns = ["idiot","toaster","legend","therapy","psychic","knife","sandwich","lettuce","kitty","friendly grandma","french chef","antidepressant drug","coffee pot","tank","private investor","elastic band","telephone","mad cow disease","karate","pistol","kitty cat","hairy leg","liquid oxygen","laser beams","messiness","trust fund","dog poop","dragon","mediation","patrolman","toilet seat","haunted graveyard","wrinkle","multi-billionaire","mental disorder","boiling water","best failure","pizza"]

let verbs = ["is","surrounds","stabs","returns","medicates","blindsides","flaps","trips","harasses","traps","explodes","sketches","scatters","challenges","fights","buries","splatters","smacks","balances","pokes","critiques","fears","initiates","runs over","cooks","imprisons","underestimates","shreds","drinks","disputes","echos","mimics","underrates","taunts"]

let adjectives = ["dead","hairless","sadistic","metal","wild","domesticated","abnormal","medicated","cocky","massive","disrespectful","impressive","hilarious","sexy","hot","bearded","violent","slimy","insanely creepy" ,"talking","naked","angry","shaky","deep","sick","zippy","fluffy","frozen","unholy","filthy","fighting","harsh","frisky","greedy","crawly","insane","hideous","abusive","hateful","idiotic","twisted","useless","yapping","magical","arrogant","flirting","high-end","insecure","slippery","stubborn","sinister","cowardly","haunting","startled","demanding","offensive","nighttime","disgusting","disturbing","rebellious","hyperactive","infuriating","territorial","mischievous","misunderstood","mentally impaired"]

let adverbs = ["carefully","easily","sadly"]

let prepositionsCommon = ["of","from","to","with","at","in","for","about","by"]

let prepositions = ["easily","sadly","above","across","after","against","along","among","around","as","before","behind","below","beneath","beside","between","beyond","despite","down","during","except","inside","into","like","near","off","on","onto","opposite","out","outside","over","past","round","since","than","through","towards","under","underneath","unlike","until","up","upon","via","within","without"]

let pronounsCommon = ["I","me","you","we","us","they","them","this","that"]

let pronouns = ["she","her","he","ours","mine","him","his","hers","himself","myself","who","what","which"]

let conjunctions = ["and","or","but"]

let determinersCommon = ["the","a"]

let determiners = ["your","less","its","no","this","that","many","both","any","my"]

//Emotive Words

let anger = ["ordeal","repulsive","scandal","shameful","shocking","terrible","tragic","appalled","harmful","enraged","offensive","aggressive","frustrated","critical","violent","furious","rebellious","impatient","sarcastic","poisonous","jealous","revengeful","powerless","mean"]

let happy = ["blissful","joyous","happy","delighted","thankful","festive","satisfied","sunny","cheerful","glorious","innocent","world","playful","courageous","optimistic","frisky","thrilled","wonderful","funny","tickled","vigorous","creative","helpful","pleased","comfortable","surprised","bright","blessed","vibrant"]

let urgency = ["instantly","quick","superior","tremendously","limited","reduced","save","safe","worthwhile"]

let confusion = ["doubtful","hesitant","stressed","tense","unsure","manipulative","disoriented","inferior","doomed","overwhelmed","pathetic","trapped","jittery","woozy","suspicious","anxious","alarmed","panicked","threatened","insecure","don't"]

let inspired = ["motivated","eager","enthusiastic","bold","brave","daring","hopeful","upbeat","balanced","fine","okay","fulfilled","authentic","sure","reliable","privileged"]

let relaxed = ["calm","comfortable","quiet","relaxed","certain","bright","balanced","genuine","radiant","smiling","efficient","fluid","light","still","natural","laughing","natural","graceful"]

//Pass Phrase Words

let passPhrase = ["dragon","toaster","toilet seat","therapy","psychic","trust fund","sandwich","lettuce","kitty","friendly grandma","toenail"]

//Entered Senternce
class QuestionSentence {
    var sentenceStructure: String
    var difficulty: String
    var subjects: [String]?
    var verbs : [String]?
    var objects: [String]?
    var adjectives : [String]?
    var adverbs : [String]?
    
    init(sentenceStructure: String, difficulty: String,  subjects: [String]?, verbs: [String]?, objects: [String]?, adjectives: [String]?, adverbs: [String]?) {
        self.sentenceStructure = sentenceStructure
        self.difficulty = difficulty
        self.subjects = subjects
        self.verbs = verbs
        self.objects = objects
        self.adjectives = adjectives
        self.adverbs = adverbs
    }
}

let easySentenceStructures = ["The *subject* *verb* a *object*."]

//Entered Senternce
class QuestionSentenceItem {
    var value: String
    var type: String
    var isSelected: Bool
    var wordsList: [String]
    
    init(value: String, type: String,  isSelected: Bool, wordsList: [String]) {
        self.value = value
        self.type = type
        self.isSelected = isSelected
        self.wordsList = wordsList
    }
}

