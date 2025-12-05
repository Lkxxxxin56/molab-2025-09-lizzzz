//
//  DreamMotif.swift
//  Dreamscape
//
//  Created by Kexin Liu on 12/3/25.
//

import Foundation

// MARK: - Motif Model

struct Motif: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let shortMeaning: String
    let longMeaning: String
}

// MARK: - Category Model

struct MotifCategory: Identifiable {
    let id = UUID()
    let name: String
    let motifs: [Motif]
}

// MARK: - Sample Data

extension MotifCategory {
    static let sampleData: [MotifCategory] = [
        MotifCategory(
            name: "Places & Settings",
            motifs: [
                Motif(
                    name: "House",
                    icon: "house.fill",
                    shortMeaning: "Symbol of the self or inner life.",
                    longMeaning:
                    """
                    Houses in dreams traditionally represent the self — your mind, your identity, and your emotional or psychological structure. 
                    
                    • Different rooms symbolize different aspects of your inner world: 
                        – Attics often represent stored memories, hidden thoughts, or intellectual concerns.  
                        – Basements connect to fears, suppressed emotions, or the subconscious.  
                        – Bedrooms relate to rest, intimacy, and vulnerability.  
                        – Kitchens represent nourishment, creativity, and emotional warmth.
                    
                    • The condition of the house (old, new, broken, luxurious) often reflects how you currently feel about your life or inner stability.
                    
                    Dream houses appear most often during periods of self-reflection, personal change, or emotional restructuring.
                    """
                ),
                Motif(
                    name: "School / Classroom",
                    icon: "book.fill",
                    shortMeaning: "Learning, pressure, or evaluation.",
                    longMeaning:
                    """
                    School dreams are incredibly common, even among adults long finished with school. They symbolize:
                    
                    • A sense of being evaluated, judged, or tested in waking life  
                    • Fear of falling behind or not meeting expectations  
                    • Transitions where you must “learn” new roles or adapt quickly  
                    • Situations involving deadlines, performance anxiety, or comparison
                    
                    Recurring school dreams often appear during job changes, relationship shifts, and self-development phases.
                    """
                ),
                Motif(
                    name: "City / Streets",
                    icon: "building.2.fill",
                    shortMeaning: "Busy thoughts or social overwhelm.",
                    longMeaning:
                    """
                    Cities represent complexity, movement, noise, and countless choices — just like the mind during busy or stressful periods.
                    
                    • Getting lost in a city can indicate confusion, uncertainty, or feeling directionless.  
                    • Bright, lively cities may reflect social confidence or excitement.  
                    • Chaotic or dark cities may represent overstimulation or emotional overload.
                    
                    Streets in dreams symbolize the “path” you are taking in life — including obstacles, crossroads, and new directions.
                    """
                ),
                Motif(
                    name: "Bridge",
                    icon: "rectangle.portrait.and.arrow.right.fill",
                    shortMeaning: "Crossing between phases.",
                    longMeaning:
                    """
                    Bridges are powerful transformation symbols — they mark an important shift from one phase of life to another.
                    
                    • Crossing a stable bridge suggests confidence in moving forward.  
                    • A shaky or broken bridge may reflect doubt or fear of change.  
                    • Looking at a bridge from afar can symbolize preparing for transition.
                    
                    Dream bridges often appear during identity shifts, relationship changes, relocations, or emotional breakthroughs.
                    """
                )
            ]
        ),
        
        MotifCategory(
            name: "Movement & Body",
            motifs: [
                Motif(
                    name: "Falling",
                    icon: "arrow.down.circle.fill",
                    shortMeaning: "Loss of control or sudden change.",
                    longMeaning:
                    """
                    Falling dreams are among the most universal symbols of instability or fear. They may reflect:
                    
                    • Feeling unsupported or “dropped” by someone  
                    • Fear of failure, disappointment, or losing control  
                    • Rapid life transitions that feel overwhelming  
                    • Anxiety about not meeting expectations
                    
                    Falling right before waking is sometimes connected to a physical muscle reflex — representing the mind-body link in stress.
                    """
                ),
                Motif(
                    name: "Flying",
                    icon: "bird.fill",
                    shortMeaning: "Freedom or rising above limitations.",
                    longMeaning:
                    """
                    Flying dreams often evoke empowerment, creativity, and lightness. They symbolically reflect:
                    
                    • Rising above problems or gaining new perspective  
                    • Feeling liberated from constraints or expectations  
                    • A desire for independence and personal expression  
                    • Spiritual or emotional elevation
                    
                    Difficulty staying airborne can indicate insecurity, self-doubt, or fear of leaving the familiar behind.
                    """
                ),
                Motif(
                    name: "Being Chased",
                    icon: "figure.run",
                    shortMeaning: "Avoiding stress or unresolved issues.",
                    longMeaning:
                    """
                    Chase dreams are not about the pursuer — they are about avoidance.
                    
                    • The chaser often represents something internal: fear, responsibility, guilt, or emotion.  
                    • Running symbolizes coping strategies: avoidance, escape, or denial.  
                    • If you hide, freeze, or fight back, those reactions can reflect real-life conflict responses.
                    
                    These dreams often appear when you avoid difficult conversations, emotions, or decisions.
                    """
                ),
                Motif(
                    name: "Teeth Falling Out",
                    icon: "face.smiling.inverse",
                    shortMeaning: "Vulnerability, insecurity, or self-image.",
                    longMeaning:
                    """
                    Teeth represent appearance, communication, and personal power.
                    
                    • Losing teeth may reflect concerns about attractiveness, competence, or being understood.  
                    • Breaking or crumbling teeth connect to feelings of fragility or losing control.  
                    • Pulling out your own teeth may symbolize self-inflicted pressure or destructive habits.
                    
                    These dreams often appear during transitions, public-facing roles, or moments of emotional vulnerability.
                    """
                )
            ]
        ),
        
        MotifCategory(
            name: "Objects & Things",
            motifs: [
                Motif(
                    name: "Door",
                    icon: "door.left.hand.closed",
                    shortMeaning: "Opportunities, boundaries, or decisions.",
                    longMeaning:
                    """
                    Doors symbolize your access to new experiences, people, or emotional states.
                    
                    • Open doors represent opportunities or emotional readiness.  
                    • Closed or locked doors may signal barriers, uncertainty, or resistance.  
                    • Endless hallways of doors suggest overwhelm or too many choices.
                    
                    Pay attention to whether you choose to enter, hesitate, or turn away — each reveals your relationship to change.
                    """
                ),
                Motif(
                    name: "Phone",
                    icon: "iphone.gen3",
                    shortMeaning: "Communication or connection issues.",
                    longMeaning:
                    """
                    Phones symbolize how you reach others — and how others reach you.
                    
                    • Broken phones reflect communication breakdowns.  
                    • Missed calls may symbolize missed opportunities or emotional disconnection.  
                    • Receiving calls from unknown numbers represents messages from the subconscious.
                    
                    When technology fails in dreams, it often highlights anxiety about expressing needs or feeling heard.
                    """
                ),
                Motif(
                    name: "Train",
                    icon: "tram.fill",
                    shortMeaning: "Direction, timing, or life path.",
                    longMeaning:
                    """
                    Trains follow predetermined tracks, making them powerful symbols for:
                    
                    • Feeling “on track” or “off track” in life  
                    • Social or cultural expectations you feel pressured to follow  
                    • Timing concerns: missing trains = fear of missing out
                    
                    Smooth train rides suggest flow and alignment; chaotic rides reflect pressure or life-speed overwhelm.
                    """
                ),
                Motif(
                    name: "Mirror",
                    icon: "rectangle.portrait",
                    shortMeaning: "Identity, self-reflection, or self-perception.",
                    longMeaning:
                    """
                    Mirrors reflect both your self-image and your deeper identity.
                    
                    • A clear reflection suggests self-awareness or acceptance.  
                    • A distorted or unfamiliar reflection may symbolize inner conflict or transformation.  
                    • Being unable to find your reflection hints at loss of identity or uncertainty.
                    
                    Mirror dreams are especially common during transitions, reinvention phases, or emotional disconnect.
                    """
                )
            ]
        ),
        
        MotifCategory(
            name: "Nature & Elements",
            motifs: [
                Motif(
                    name: "Water",
                    icon: "drop.fill",
                    shortMeaning: "Emotions, depth, or subconscious states.",
                    longMeaning:
                    """
                    Water symbolizes emotional flow and subconscious depth.
                    
                    • Calm water reflects peace, balance, or emotional clarity.  
                    • Turbulent water signals inner conflict or overwhelm.  
                    • Deep oceans reflect mystery, fear of the unknown, or emotional depth.  
                    • Floods suggest emotions rising faster than you can manage.
                    
                    Movement through water (floating, sinking, swimming) reveals how you navigate emotional experiences.
                    """
                ),
                Motif(
                    name: "Forest",
                    icon: "leaf.fill",
                    shortMeaning: "Mystery, exploration, or feeling lost.",
                    longMeaning:
                    """
                    Forests represent the unknown — both externally and internally.
                    
                    • Wandering in a forest can symbolize a search for meaning or clarity.  
                    • Dense forests reflect confusion, complexity, or emotional fog.  
                    • Bright, magical forests represent creativity, renewal, and discovery.
                    
                    Forest dreams often appear during personal exploration or self-redefinition.
                    """
                ),
                Motif(
                    name: "Fire",
                    icon: "flame.fill",
                    shortMeaning: "Intense emotion, destruction, or transformation.",
                    longMeaning:
                    """
                    Fire is a dual symbol — destructive and transformative.
                    
                    • Wildfire reflects overwhelming emotion, anger, or conflict.  
                    • Contained fire (candles, hearths) symbolizes passion, warmth, or inspiration.  
                    • Burning objects may represent letting go of the old to make space for the new.
                    
                    Fire dreams often accompany periods of emotional intensity or major personal change.
                    """
                ),
                Motif(
                    name: "Storm",
                    icon: "cloud.bolt.fill",
                    shortMeaning: "Inner turbulence or conflict.",
                    longMeaning:
                    """
                    Storms reflect emotional upheaval or unresolved tension.
                    
                    • Thunderstorms symbolize explosive emotions or unexpected conflict.  
                    • Tornadoes represent chaotic thoughts or escalating stress.  
                    • Standing safely during a storm may reflect emotional resilience.
                    
                    Storm dreams often precede major releases, decisions, or breakthroughs.
                    """
                )
            ]
        ),
        
        MotifCategory(
            name: "People & Creatures",
            motifs: [
                Motif(
                    name: "Stranger",
                    icon: "person.crop.circle.badge.questionmark",
                    shortMeaning: "Unknown or emerging aspects of self.",
                    longMeaning:
                    """
                    Strangers in dreams often represent parts of yourself you’re not fully aware of yet.
                    
                    • Kind strangers may reflect untapped strengths or desires.  
                    • Threatening strangers represent suppressed fears or conflicts.  
                    • Mysterious strangers can symbolize new roles or identities forming.
                    
                    The stranger’s behavior often mirrors the emotional tone of your own inner developments.
                    """
                ),
                Motif(
                    name: "Child",
                    icon: "figure.and.child.holdinghands",
                    shortMeaning: "Vulnerability, innocence, or new beginnings.",
                    longMeaning:
                    """
                    Children symbolize the aspects of yourself that are raw, vulnerable, pure, or developing.
                    
                    • Caring for a child suggests protecting a new idea or identity.  
                    • Losing a child may symbolize fear of failure or neglecting your needs.  
                    • Your younger self appearing represents revisiting memories, wounds, or forgotten dreams.
                    
                    These dreams are common during times of emotional healing or creativity.
                    """
                ),
                Motif(
                    name: "Animal",
                    icon: "pawprint.fill",
                    shortMeaning: "Instinct, habit, or raw emotion.",
                    longMeaning:
                    """
                    Animals represent instinctual drives or emotional states.
                    
                    • Predators reflect fear, anger, or confrontation.  
                    • Pets symbolize comfort, attachment, or responsibility.  
                    • Birds symbolize freedom, perspective, or spiritual insight.
                    
                    How the animal behaves reveals how you relate to your instincts — with fear, control, partnership, or avoidance.
                    """
                ),
                Motif(
                    name: "Shadowy Figure",
                    icon: "eye.slash.fill",
                    shortMeaning: "Hidden fear or the unknown.",
                    longMeaning:
                    """
                    Shadow figures are some of the strongest symbols for the unconscious.
                    
                    • They represent emotions, memories, or parts of yourself you aren’t ready to face.  
                    • They may appear at transitional moments, when identity or direction feels unclear.  
                    • The fear they provoke often mirrors inner conflict rather than external danger.
                    
                    These dreams invite reflection rather than avoidance — the shadow often holds important psychological insight.
                    """
                )
            ]
        )
    ]
}
