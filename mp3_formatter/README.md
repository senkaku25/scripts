# MP3 Formatter

Python 3 script to rename MP3 files to the format `Artist - Title.mp3`, and ID3-tag the MP3 files with the corresponding title and artist.

## Usage

1. Find the music album to rename at [HikarinoAkari](http://hikarinoakariost.info/)
  * Don't judge me; if you judge me for this you can't use this. It's in the [LICENCE](https://github.com/jleung51/scripts/tree/master/mp3_formatter/LICENCE#L14), I swear, this is legit
2. Place the MP3 files into the directory `mp3-formatter/mp3/`, making sure that they are ordered by track number
3. `cd` to `mp3-formatter/`
4. Run:

```
./mp3_formatter.sh URL_TO_TRACKLIST ARTIST_NAME
```

## Setup

### Python 3 Installation

Run:

```
sudo apt-get install python3
```

### External Modules

#### [Pytag](http://pytag.readthedocs.io/en/latest/)

To install, run:

```
sudo apt-get install python3-pip
pip3 install pytag
```

#### [Requests](http://docs.python-requests.org/en/master/)

To install, run:

```
sudo apt-get install python3-pip
pip3 install requests
```
