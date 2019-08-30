﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class HUD : MonoBehaviour {
    public Character character;

    Text scoreText;
    Text timeText;
    Text timeTitleText;
    Text ringsText;
    Text ringsTitleText;
    Text livesText;

    void InitReferences() {
        scoreText = transform.Find("Score Content").GetComponent<Text>();
        timeText = transform.Find("Time Content").GetComponent<Text>();
        timeTitleText = transform.Find("Time Title").GetComponent<Text>();
        ringsText = transform.Find("Rings Content").GetComponent<Text>();
        ringsTitleText = transform.Find("Rings Title").GetComponent<Text>();
        livesText = transform.Find("Lives Content").GetComponent<Text>();
    }

    // Start is called before the first frame update
    void Start() {
        InitReferences();
    }

    // Update is called once per frame
    void Update() {
        scoreText.text = character.score.ToString();
        ringsText.text = character.rings.ToString();
        livesText.text = character.lives.ToString();

        timeText.text = (
            Mathf.Floor(character.timer / 60).ToString() +
            ":" +
            Mathf.Floor(character.timer % 60).ToString().PadLeft(2, '0')
        );

        bool shouldFlash = (((int)(character.timer * 60)) % 16) > 8;
        if (shouldFlash) {
            if (character.timer >= 9 * 60) timeTitleText.color = Color.red;
            if (character.rings <= 0) ringsTitleText.color = Color.red;
        } else {
            timeTitleText.color = Color.white;
            ringsTitleText.color = Color.white;
        }
    }
}